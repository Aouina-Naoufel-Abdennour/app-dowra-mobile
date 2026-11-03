import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/booking_providers.dart';
import '../core/bookings.dart';
import '../core/catalogue_providers.dart';
import '../core/format.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';

/// Cartes cadeaux (4.4) : mes cartes (offertes, reçues) et offrir un montant ou une sortie.
class GiftCardsScreen extends ConsumerStatefulWidget {
  const GiftCardsScreen({super.key, this.eventSlug});

  final String? eventSlug;

  @override
  ConsumerState<GiftCardsScreen> createState() => _GiftCardsScreenState();
}

class _GiftCardsScreenState extends ConsumerState<GiftCardsScreen> with WidgetsBindingObserver {
  int? _amount;
  final _custom = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _message = TextEditingController();
  String _card = 'cib';
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (final c in [_custom, _name, _phone, _message]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) ref.invalidate(myGiftCardsProvider);
  }

  Future<void> _buy(int amount) async {
    final t = AppLocalizations.of(context);
    if (_name.text.trim().isEmpty) {
      setState(() => _error = t.giftRecipientRequired);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final url = await ref.read(repositoryProvider).buyGiftCard({
        if (widget.eventSlug != null) 'event_slug': widget.eventSlug else 'amount': amount,
        'recipient_name': _name.text.trim(),
        if (_phone.text.trim().isNotEmpty) 'recipient_phone': _phone.text.trim(),
        if (_message.text.trim().isNotEmpty) 'message': _message.text.trim(),
        'method': _card,
      });
      await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
      ref.invalidate(myGiftCardsProvider);
    } catch (error) {
      if (mounted) setState(() => _error = errorText(context, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = ref.watch(localeProvider);
    final palette = context.palette;
    final signedIn = ref.watch(sessionProvider).value != null;
    final options = ref.watch(giftOptionsProvider);
    final cards = ref.watch(myGiftCardsProvider);
    final event = widget.eventSlug == null ? null : ref.watch(eventProvider(widget.eventSlug!)).value;

    return Scaffold(
      appBar: AppBar(title: Text(t.giftCards)),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 40), children: [
        const Dowri(DowriMood.fete, size: 110),
        const SizedBox(height: 8),
        BrandTitle(t.giftTitle, t.giftTitleEm, size: 28),
        const SizedBox(height: 8),
        Text(t.giftLead, style: TextStyle(color: palette.muted, height: 1.5)),
        if (!signedIn) ...[const SizedBox(height: 16), const GuestInvite()],
        if (signedIn)
          cards.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (list) => list.isEmpty
                ? const SizedBox.shrink()
                : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    const SizedBox(height: 20),
                    Text(t.myGiftCards, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    for (final card in list) _GiftTile(card: card),
                  ]),
          ),
        if (signedIn)
          options.when(
            loading: () => const Padding(padding: EdgeInsets.all(30), child: Center(child: CircularProgressIndicator())),
            error: (_, _) => RetryCard(onRetry: () => ref.invalidate(giftOptionsProvider)),
            data: (o) {
              final amount = event != null ? (event.card.priceFrom ?? 0) : (_amount == -1 ? int.tryParse(_custom.text) ?? 0 : (_amount ?? o.suggested.elementAtOrNull(1) ?? o.min));
              final fees = o.fees.forAmount(amount, _card);
              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const SizedBox(height: 24),
                Text(t.giftOffer, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                if (event != null)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: palette.pale, borderRadius: BorderRadius.circular(16)),
                    child: Text(t.giftEvent(event.card.title), style: const TextStyle(fontWeight: FontWeight.w700)),
                  )
                else ...[
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final value in o.suggested)
                      ChoicePill(label: formatPrice(lang, value), selected: amount == value && _amount != -1, onTap: () => setState(() => _amount = value)),
                    ChoicePill(label: t.giftOther, selected: _amount == -1, onTap: () => setState(() => _amount = -1)),
                  ]),
                  if (_amount == -1)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(controller: _custom, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), decoration: InputDecoration(labelText: '${o.min} – ${o.max} DA')),
                    ),
                ],
                const SizedBox(height: 12),
                TextField(controller: _name, textCapitalization: TextCapitalization.words, decoration: InputDecoration(labelText: t.giftRecipient)),
                const SizedBox(height: 10),
                TextField(controller: _phone, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: t.giftRecipientPhone)),
                const SizedBox(height: 10),
                TextField(controller: _message, maxLength: 300, maxLines: 2, decoration: InputDecoration(labelText: t.giftMessage)),
                Text(t.paymentCard, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  ChoicePill(label: 'CIB', selected: _card == 'cib', onTap: () => setState(() => _card = 'cib')),
                  ChoicePill(label: 'Edahabia', selected: _card == 'edahabia', onTap: () => setState(() => _card = 'edahabia')),
                ]),
                const SizedBox(height: 10),
                Row(children: [Text(t.paymentFees, style: TextStyle(color: palette.muted)), const Spacer(), Text(formatPrice(lang, fees), style: const TextStyle(fontWeight: FontWeight.w700))]),
                if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: const TextStyle(color: DowraColors.error, fontWeight: FontWeight.w700))),
                const SizedBox(height: 14),
                GradientButton(label: t.bookPay(formatPrice(lang, amount + fees)), loading: _busy, onPressed: amount > 0 ? () => _buy(amount) : null),
              ]);
            },
          ),
      ]),
    );
  }
}

class _GiftTile extends ConsumerWidget {
  const _GiftTile({required this.card});

  final GiftCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final lang = ref.watch(localeProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(gradient: DowraColors.gradient, borderRadius: BorderRadius.circular(22)),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(card.isBuyer ? t.giftSentTo(card.recipientName ?? '') : t.giftReceived, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          SelectableText(card.code, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          Text(t.giftBalance(formatPrice(lang, card.balance)), style: const TextStyle(fontWeight: FontWeight.w700)),
          Text([card.status.label, if (card.expiresAt != null) t.giftValidUntil(formatLongDay(lang, card.expiresAt!))].join(' · '), style: const TextStyle(fontSize: 12.5)),
          if (card.eventTitle != null) Text(card.eventTitle!, style: const TextStyle(fontSize: 12.5)),
        ]),
      ),
    );
  }
}
