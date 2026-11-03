import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/booking_providers.dart';
import '../core/bookings.dart';
import '../core/catalogue.dart';
import '../core/catalogue_providers.dart';
import '../core/format.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/seat_picker.dart';

/// Réserver (7.1) : séance, billets, ramassage, options, participants, mode et paiement, puis page de paiement.
class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    if (ref.watch(sessionProvider).value == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.bookTitle)),
        body: const Padding(padding: EdgeInsets.all(20), child: GuestInvite()),
      );
    }
    final event = ref.watch(eventProvider(slug));
    final availability = ref.watch(availabilityProvider(slug));
    return Scaffold(
      appBar: AppBar(title: Text(t.bookTitle)),
      body: switch ((event, availability)) {
        (AsyncData(value: final e), AsyncData(value: final a)) => _BookingForm(event: e, availability: a),
        (AsyncError(), _) || (_, AsyncError()) => Padding(
          padding: const EdgeInsets.all(20),
          child: RetryCard(
            onRetry: () {
              ref.invalidate(eventProvider(slug));
              ref.invalidate(availabilityProvider(slug));
            },
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _BookingForm extends ConsumerStatefulWidget {
  const _BookingForm({required this.event, required this.availability});

  final EventDetail event;
  final Availability availability;

  @override
  ConsumerState<_BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends ConsumerState<_BookingForm> {
  EventDetail get e => widget.event;
  Availability get a => widget.availability;

  late int? _session = (a.sessions.where((s) => !s.soldOut).firstOrNull ?? a.sessions.firstOrNull)?.id;
  final Map<int, int> _quantities = {};
  final Map<String, int> _options = {};
  String? _pickup;
  final List<TextEditingController> _holders = [];
  late String _channel = e.saleModeValue == 'reservation' ? 'reservation' : 'en_ligne';
  late String _method = e.simplePaymentMethods.firstOrNull?.value ?? 'sur_place';
  final _note = TextEditingController();
  final _gift = TextEditingController();
  final _promo = TextEditingController();
  final Map<int, List<String>> _seats = {};
  int? _seatTicket;
  ({int session, SeatMap? map})? _seatMap;
  String _card = 'cib';
  bool _busy = false;
  String? _error;

  EventSessionInfo? get session => a.sessions.where((s) => s.id == _session).firstOrNull;
  int get count => _quantities.values.fold(0, (sum, q) => sum + q);
  int get seats => e.tickets.fold(0, (sum, ticket) => sum + (_quantities[ticket.id] ?? 0) * ticket.seats);
  int get ticketsTotal => e.tickets.fold(0, (sum, ticket) => sum + (_quantities[ticket.id] ?? 0) * ticket.price);
  int get shuttleTotal => (session?.pickupPoints.where((p) => p.label == _pickup).firstOrNull?.price ?? 0) * count;
  int get groupDiscount => e.groupOffer != null && count >= e.groupOffer!.min ? (ticketsTotal * e.groupOffer!.percent / 100).floor() : 0;
  int get total => ticketsTotal + e.bookingOptions.fold<int>(0, (sum, option) => sum + (_options[option.code] ?? 0) * option.price) + shuttleTotal - groupDiscount;
  List<TicketInfo> get numbered => e.tickets.where((ticket) => ticket.numbered).toList();
  int get limit => (a.maxPerPerson - a.alreadyBooked).clamp(0, 50);

  @override
  void dispose() {
    for (final controller in _holders) {
      controller.dispose();
    }
    _note.dispose();
    _gift.dispose();
    _promo.dispose();
    super.dispose();
  }

  /// Plan de salle de la séance choisie, chargé une fois par séance.
  Future<void> _loadSeats(int sessionId) async {
    if (numbered.isEmpty || _seatMap?.session == sessionId) return;
    _seatMap = (session: sessionId, map: null);
    try {
      final map = await ref.read(repositoryProvider).seats(sessionId);
      if (mounted && _session == sessionId) setState(() => _seatMap = (session: sessionId, map: map));
    } catch (_) {
      if (mounted) setState(() => _seatMap = null);
    }
  }

  void _toggleSeat(int ticketId, String seat) {
    final ticket = e.tickets.firstWhere((item) => item.id == ticketId);
    final current = _seats[ticketId] ?? const <String>[];
    final next = current.contains(seat) ? current.where((item) => item != seat).toList() : [...current, seat];
    if (_setQuantity(ticket, next.length)) setState(() => _seats[ticketId] = next);
  }

  bool _setQuantity(TicketInfo ticket, int value) {
    final s = session;
    if (s == null || value < 0) return false;
    final next = {..._quantities, ticket.id: value};
    final nextCount = next.values.fold(0, (sum, q) => sum + q);
    final nextSeats = e.tickets.fold(0, (sum, t) => sum + (next[t.id] ?? 0) * t.seats);
    final left = s.ticketsRemaining[ticket.id];
    if (value > (_quantities[ticket.id] ?? 0) && (nextCount > limit || (left != null && value > left) || (s.remaining != null && nextSeats > s.remaining!))) return false;
    setState(() {
      _quantities[ticket.id] = value;
      while (_holders.length < nextCount) {
        _holders.add(TextEditingController());
      }
    });
    return true;
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context);
    final s = session;
    if (s == null || count == 0) {
      setState(() => _error = t.bookChoose);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final repository = ref.read(repositoryProvider);
    try {
      final booking = await repository.book({
        'event_session_id': s.id,
        'channel': _channel,
        'items': [
          for (final entry in _quantities.entries)
            if (entry.value > 0) {'ticket_type_id': entry.key, 'quantity': entry.value},
        ],
        if (_channel == 'reservation') 'payment_method': _method,
        if (s.pickupPoints.isNotEmpty) 'pickup_point': _pickup,
        'options': [
          for (final entry in _options.entries)
            if (entry.value > 0) {'code': entry.key, 'quantity': entry.value},
        ],
        if (e.nominativeTickets) 'holders': [for (final c in _holders.take(count)) c.text.trim()],
        if (_note.text.trim().isNotEmpty) 'note': _note.text.trim(),
        if (_channel == 'en_ligne' && _gift.text.trim().isNotEmpty) 'gift_card_code': _gift.text.trim().toUpperCase(),
        if (_promo.text.trim().isNotEmpty) 'promo_code': _promo.text.trim().toUpperCase(),
        if (_seats.isNotEmpty)
          'seats': [
            for (final entry in _seats.entries)
              for (final seat in entry.value) {'ticket_type_id': entry.key, 'seat': seat},
          ],
      });
      if (booking.status.value == 'bloquee') {
        final payment = await repository.pay(booking.code, method: _card);
        if (payment.paymentUrl != null) {
          await launchUrl(Uri.parse(payment.paymentUrl!), mode: LaunchMode.inAppBrowserView);
        }
      }
      ref.invalidate(availabilityProvider(e.card.slug));
      ref.invalidate(bookingsProvider('upcoming'));
      if (mounted) context.pushReplacement('/billets/${booking.code}');
    } catch (error) {
      if (mounted) setState(() => _error = errorText(context, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _waitlist(EventSessionInfo s, bool join) async {
    final t = AppLocalizations.of(context);
    final repository = ref.read(repositoryProvider);
    try {
      if (join) {
        await repository.joinWaitlist(s.id, ticketTypeId: e.tickets.firstOrNull?.id, quantity: count.clamp(1, 50));
      } else {
        await repository.leaveWaitlist(s.id);
      }
      ref.invalidate(availabilityProvider(e.card.slug));
      if (mounted && join) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.waitlistJoined)));
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(context, error))));
    }
  }

  Future<void> _group(String payMode) async {
    final t = AppLocalizations.of(context);
    final s = session;
    if (s == null) return;
    try {
      final url = await ref.read(repositoryProvider).createGroup(s.id, payMode);
      await SharePlus.instance.share(ShareParams(text: '${e.card.title} · $url', subject: t.groupShare));
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(context, error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = ref.watch(localeProvider);
    final palette = context.palette;
    final s = session;
    final channels = e.saleModeValue == 'les_deux' ? ['en_ligne', 'reservation'] : [_channel];
    final deposit = _channel == 'reservation' && _method == 'acompte' && e.depositPercent != null ? (total * e.depositPercent! / 100).ceil() : null;
    final hasGift = _gift.text.trim().isNotEmpty;
    final fees = _channel == 'en_ligne' && !hasGift ? e.paymentFees.forAmount(total, _card) : 0;

    if (s != null && numbered.isNotEmpty && _seatMap?.session != s.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadSeats(s.id));
    }

    if (!e.canBook || a.sessions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: DowriCard(mood: DowriMood.repos, text: t.bookNotAvailable),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(e.card.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.2)),
              _Title(t.bookSession),
              for (final option in a.sessions)
                _SessionTile(
                  session: option,
                  selected: option.id == _session,
                  waitlist: a.waitlist[option.id],
                  onTap: () => setState(() {
                    _session = option.id;
                    _quantities.clear();
                    _seats.clear();
                    _pickup = null;
                  }),
                  onWaitlist: (join) => _waitlist(option, join),
                ),
              if (s != null && !s.soldOut) ...[
                _Title(t.tickets),
                Text('${t.maxPerPerson(a.maxPerPerson)}${a.alreadyBooked > 0 ? ' · ${t.alreadyBooked(a.alreadyBooked)}' : ''}', style: TextStyle(color: palette.muted, fontSize: 13)),
                const SizedBox(height: 8),
                for (final ticket in e.tickets.where((ticket) => !ticket.numbered))
                  _Stepper(
                    title: ticket.name,
                    subtitle: [
                      ticket.price == 0 ? t.free : formatPrice(lang, ticket.price),
                      if (ticket.seats > 1) t.placesCount(ticket.seats),
                      if ((s.ticketsRemaining[ticket.id] ?? 99) <= 5) (s.ticketsRemaining[ticket.id] == 0 ? t.soldOut : t.placesLeft(s.ticketsRemaining[ticket.id]!)),
                    ].join(' · '),
                    value: _quantities[ticket.id] ?? 0,
                    canAdd: ticket.onSale && s.ticketsRemaining[ticket.id] != 0,
                    onChanged: (value) => _setQuantity(ticket, value),
                  ),
                if (e.groupOffer != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: DowraColors.sun.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(16)),
                    child: Text(t.groupOffer(e.groupOffer!.percent, e.groupOffer!.min), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                if (numbered.isNotEmpty) ...[
                  _Title(t.seatsTitle),
                  if (_seatMap?.session == s.id && _seatMap?.map != null)
                    SeatPicker(
                      map: _seatMap!.map!,
                      tickets: numbered,
                      active: _seatTicket ?? numbered.first.id,
                      onActive: (id) => setState(() => _seatTicket = id),
                      selected: _seats,
                      onToggle: _toggleSeat,
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
                if (s.pickupPoints.isNotEmpty) ...[
                  _Title(t.pickups),
                  RadioGroup<String>(
                    groupValue: _pickup,
                    onChanged: (value) => setState(() => _pickup = value),
                    child: Column(
                      children: [
                        for (final point in s.pickupPoints)
                          RadioListTile<String>(
                            value: point.label,
                            contentPadding: EdgeInsets.zero,
                            title: Text(point.label, style: const TextStyle(fontWeight: FontWeight.w700)),
                            subtitle: point.time != null || (point.price ?? 0) > 0
                                ? Text([point.time, if ((point.price ?? 0) > 0) '${t.shuttle} ${formatPrice(lang, point.price!)}'].whereType<String>().join(' · '))
                                : null,
                          ),
                      ],
                    ),
                  ),
                ],
                if (e.bookingOptions.isNotEmpty) ...[
                  _Title(t.bookOptions),
                  for (final option in e.bookingOptions)
                    _Stepper(
                      title: option.name,
                      subtitle: formatPrice(lang, option.price),
                      value: _options[option.code] ?? 0,
                      canAdd: (_options[option.code] ?? 0) < (count == 0 ? 1 : count),
                      onChanged: (value) => setState(() => _options[option.code] = value.clamp(0, 50)),
                    ),
                ],
                if (e.nominativeTickets && count > 0) ...[
                  _Title(t.bookHolders),
                  Text(t.bookHoldersHint, style: TextStyle(color: palette.muted, fontSize: 13)),
                  for (var i = 0; i < count; i++)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: _holders[i],
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(labelText: t.bookHolder(i + 1)),
                      ),
                    ),
                ],
                if (channels.length > 1 || _channel == 'reservation') ...[
                  _Title(t.bookChannel),
                  RadioGroup<String>(
                    groupValue: _channel,
                    onChanged: (value) => setState(() => _channel = value ?? _channel),
                    child: Column(
                      children: [
                        for (final channel in channels)
                          RadioListTile<String>(
                            value: channel,
                            contentPadding: EdgeInsets.zero,
                            title: Text(channel == 'en_ligne' ? t.bookOnline : t.bookSimple, style: const TextStyle(fontWeight: FontWeight.w700)),
                            subtitle: Text(channel == 'en_ligne' ? t.bookOnlineHint : t.bookSimpleHint),
                          ),
                      ],
                    ),
                  ),
                  if (_channel == 'reservation' && e.simplePaymentMethods.length > 1)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final method in e.simplePaymentMethods)
                          ChoicePill(
                            label: method.value == 'acompte' && e.depositPercent != null ? '${method.label} · ${e.depositPercent} %' : method.label,
                            selected: _method == method.value,
                            onTap: () => setState(() => _method = method.value),
                          ),
                      ],
                    ),
                  if (_channel == 'reservation')
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        controller: _note,
                        maxLength: 500,
                        maxLines: 3,
                        decoration: InputDecoration(labelText: t.bookNote),
                      ),
                    ),
                ],
                if (_channel == 'en_ligne' && total > 0) ...[
                  _Title(t.paymentCard),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoicePill(label: 'CIB', selected: _card == 'cib', onTap: () => setState(() => _card = 'cib')),
                      ChoicePill(label: 'Edahabia', selected: _card == 'edahabia', onTap: () => setState(() => _card = 'edahabia')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _gift,
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(labelText: t.giftCodeOptional, hintText: 'KDO…', prefixIcon: const Icon(Icons.card_giftcard_rounded)),
                  ),
                ],
                if (total > 0 || _promo.text.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _promo,
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(labelText: t.promoCode, helperText: _promo.text.isEmpty ? null : t.promoHint, prefixIcon: const Icon(Icons.local_offer_outlined)),
                  ),
                ],
                _Title(t.bookGroup),
                Text(t.bookGroupText, style: TextStyle(color: palette.muted, height: 1.4)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinePillButton(label: t.groupEach, icon: Icons.group_outlined, onPressed: () => _group('chacun')),
                    OutlinePillButton(label: t.groupOne, icon: Icons.volunteer_activism_outlined, onPressed: () => _group('un_pour_tous')),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (s != null && !s.soldOut)
          Container(
            padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.paddingOf(context).bottom + 14),
            decoration: BoxDecoration(
              color: palette.surface,
              border: Border(top: BorderSide(color: palette.line)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: DowraColors.error, fontWeight: FontWeight.w700),
                    ),
                  ),
                Row(
                  children: [
                    Text(t.total, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text(count == 0 ? '—' : (total == 0 ? t.free : formatPrice(lang, total)), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  ],
                ),
                if (groupDiscount > 0)
                  Row(
                    children: [
                      Text(
                        t.groupDiscount(e.groupOffer!.percent),
                        style: TextStyle(color: palette.accent, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        '−${formatPrice(lang, groupDiscount)}',
                        style: TextStyle(color: palette.accent, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                if (fees > 0)
                  Row(
                    children: [
                      Text(t.paymentFees, style: TextStyle(color: palette.muted, fontSize: 13)),
                      const Spacer(),
                      Text(
                        formatPrice(lang, fees),
                        style: TextStyle(color: palette.muted, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                if (deposit != null)
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(t.depositToPay(formatPrice(lang, deposit)), style: TextStyle(color: palette.muted, fontSize: 13)),
                  ),
                const SizedBox(height: 10),
                GradientButton(
                  label: count == 0
                      ? t.bookTitle
                      : _channel == 'reservation'
                      ? t.bookSendRequest
                      : total == 0
                      ? t.bookConfirmFree
                      : t.bookPay(formatPrice(lang, total + fees)),
                  loading: _busy,
                  onPressed: count == 0 || seats == 0 ? null : _submit,
                ),
                if (_channel == 'en_ligne' && total > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(t.bookHoldInfo, style: TextStyle(color: palette.muted, fontSize: 12)),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
  );
}

class _SessionTile extends ConsumerWidget {
  const _SessionTile({required this.session, required this.selected, required this.waitlist, required this.onTap, required this.onWaitlist});

  final EventSessionInfo session;
  final bool selected;
  final String? waitlist;
  final VoidCallback onTap;
  final ValueChanged<bool> onWaitlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final lang = ref.watch(localeProvider);
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? palette.pale : palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: selected ? palette.accent : palette.line, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(formatLongDay(lang, session.startsAt), style: const TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: palette.accent, size: 20),
                  ],
                ),
                Text([formatTime(session.startsAt), if (session.label != null) session.label!].join(' · '), style: TextStyle(color: palette.muted, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  session.soldOut ? t.soldOut : (session.remaining != null ? t.placesLeft(session.remaining!) : t.placesAvailable),
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: session.soldOut ? DowraColors.error : DowraColors.success),
                ),
                if (session.soldOut) ...[
                  const SizedBox(height: 6),
                  if (waitlist == 'proposee')
                    Text(
                      t.waitlistOffered,
                      style: TextStyle(color: palette.accent, fontWeight: FontWeight.w700),
                    )
                  else if (waitlist == 'en_attente')
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        Text(t.waitlistOn, style: TextStyle(color: palette.muted, fontSize: 13)),
                        TextButton(onPressed: () => onWaitlist(false), child: Text(t.waitlistLeave)),
                      ],
                    )
                  else
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: DowraColors.sun, foregroundColor: DowraColors.ink),
                      onPressed: () => onWaitlist(true),
                      child: Text(t.waitlistJoin),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.title, required this.subtitle, required this.value, required this.canAdd, required this.onChanged});

  final String title;
  final String subtitle;
  final int value;
  final bool canAdd;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(subtitle, style: TextStyle(color: palette.muted, fontSize: 13)),
              ],
            ),
          ),
          IconButton.outlined(onPressed: value > 0 ? () => onChanged(value - 1) : null, icon: const Icon(Icons.remove_rounded), tooltip: '−'),
          SizedBox(
            width: 30,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          IconButton.filled(
            onPressed: canAdd ? () => onChanged(value + 1) : null,
            style: IconButton.styleFrom(backgroundColor: palette.accent, foregroundColor: Colors.white),
            icon: const Icon(Icons.add_rounded),
            tooltip: '+',
          ),
        ],
      ),
    );
  }
}
