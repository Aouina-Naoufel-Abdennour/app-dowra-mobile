import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/booking_providers.dart';
import '../core/bookings.dart';
import '../core/format.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import 'tickets_screen.dart';

/// Billet (4.5) : QR codes, statut, payer, annuler, transférer, calendrier, itinéraire, organisateur.
/// La page se recharge au retour de la page de paiement.
class TicketScreen extends ConsumerStatefulWidget {
  const TicketScreen({super.key, required this.code});

  final String code;

  @override
  ConsumerState<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends ConsumerState<TicketScreen> with WidgetsBindingObserver {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  void _refresh() {
    ref.invalidate(bookingProvider(widget.code));
    ref.invalidate(bookingsProvider('upcoming'));
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(context, error))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pay(Booking booking) => _run(() async {
        final payment = await ref.read(repositoryProvider).pay(booking.code);
        if (payment.paymentUrl != null) await launchUrl(Uri.parse(payment.paymentUrl!), mode: LaunchMode.inAppBrowserView);
        _refresh();
      });

  Future<void> _cancel(Booking booking) async {
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(t.cancelBooking),
        content: Text(t.cancelBookingText),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialog, false), child: Text(t.cancel)),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: DowraColors.error), onPressed: () => Navigator.pop(dialog, true), child: Text(t.cancelBookingConfirm)),
        ],
      ),
    );
    if (ok != true) return;
    await _run(() async {
      await ref.read(repositoryProvider).cancelBooking(booking.code);
      _refresh();
    });
  }

  Future<void> _transfer(Ticket ticket) async {
    final t = AppLocalizations.of(context);
    final phone = TextEditingController();
    final name = TextEditingController();
    final action = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheet) => Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.viewInsetsOf(sheet).bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(t.transferTicket, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: t.transferPhone)),
          const SizedBox(height: 10),
          TextField(controller: name, textCapitalization: TextCapitalization.words, decoration: InputDecoration(labelText: t.transferName)),
          const SizedBox(height: 16),
          GradientButton(label: t.transferSend, onPressed: () => Navigator.pop(sheet, 'phone')),
          const SizedBox(height: 8),
          TextButton.icon(onPressed: () => Navigator.pop(sheet, 'link'), icon: const Icon(Icons.link_rounded), label: Text(t.transferLink)),
        ]),
      ),
    );
    if (action == 'phone' && phone.text.trim().isNotEmpty) {
      await _run(() async {
        final message = await ref.read(repositoryProvider).transferTicket(ticket.code, phone.text.trim(), holderName: name.text.trim().isEmpty ? null : name.text.trim());
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        _refresh();
      });
    } else if (action == 'link') {
      await _run(() async {
        final url = await ref.read(repositoryProvider).ticketLink(ticket.code);
        await SharePlus.instance.share(ShareParams(text: url, subject: t.claimShare));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final result = ref.watch(bookingProvider(widget.code));
    return Scaffold(
      appBar: AppBar(title: Text(t.ticketTitle)),
      body: result.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Padding(padding: const EdgeInsets.all(20), child: RetryCard(onRetry: _refresh)),
        data: (data) => RefreshIndicator(onRefresh: () async => _refresh(), child: _body(data.booking, data.offline)),
      ),
    );
  }

  Widget _body(Booking b, bool offline) {
    final t = AppLocalizations.of(context);
    final lang = ref.watch(localeProvider);
    final palette = context.palette;
    final mine = b.myTickets;
    final others = b.tickets.where((ticket) => !ticket.isMine).toList();

    return ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 40), children: [
      if (offline) const OfflineBanner(),
      Row(children: [StatusChip(b.status), const SizedBox(width: 8), Text(b.code, style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1))]),
      const SizedBox(height: 8),
      InkWell(onTap: () => context.push('/sorties/${b.eventSlug}'), child: Text(b.eventTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.2))),
      const SizedBox(height: 4),
      Text('${formatLongDay(lang, b.startsAt)} · ${formatTime(b.startsAt)}${b.sessionLabel != null ? ' · ${b.sessionLabel}' : ''}', style: TextStyle(color: palette.muted)),
      const SizedBox(height: 14),
      if (b.status.value == 'bloquee' && b.holdExpiresAt != null)
        _Notice(
          color: DowraColors.sun.withValues(alpha: 0.3),
          text: b.fromWaitlist ? t.fromWaitlist(formatTime(b.holdExpiresAt!)) : t.payBefore(formatTime(b.holdExpiresAt!)),
          action: GradientButton(label: (b.total ?? 0) > 0 ? t.payNow(formatPrice(lang, b.total!)) : t.bookConfirmFree, loading: _busy, onPressed: offline ? null : () => _pay(b)),
        )
      else if (b.status.value == 'en_attente' && b.respondBy != null)
        _Notice(
          color: DowraColors.sun.withValues(alpha: 0.3),
          text: [t.waitingOrganizer(formatDateTime(lang, b.respondBy!)), if (b.depositAmount != null) t.depositToPay(formatPrice(lang, b.depositAmount!))].join('\n'),
        )
      else if (b.cancelledBy != null)
        _Notice(color: palette.pale, text: [t.cancelledBy(b.cancelledBy!), if (b.cancelReason != null) b.cancelReason!].join('\n')),
      for (final ticket in mine) _TicketCard(ticket: ticket, canTransfer: ticket.isValid && b.status.value == 'confirmee' && !offline, onTransfer: () => _transfer(ticket)),
      if (mine.any((ticket) => ticket.qr != null && ticket.isValid)) Text(t.qrHint, style: TextStyle(color: palette.muted, fontSize: 13)),
      for (final ticket in others)
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: palette.pale, borderRadius: BorderRadius.circular(14)),
          child: Text('${ticket.type} · ${ticket.code} · ${ticket.transferredTo != null ? t.transferredTo(ticket.transferredTo!) : ticket.status.label}'),
        ),
      const SizedBox(height: 18),
      _Row(t.place, [b.place, b.address, b.wilaya].whereType<String>().toSet().join(', ')),
      if (b.pickupPoint != null) _Row(t.pickups, b.pickupPoint!),
      if (b.entryDeadline != null) _Row(t.entryDeadline, b.entryDeadline!),
      for (final item in b.items) _Row('${item.quantity} × ${item.name}', item.unitPrice == 0 ? t.free : formatPrice(lang, item.quantity * item.unitPrice)),
      for (final option in b.options) _Row('${option.quantity} × ${option.name}', formatPrice(lang, option.quantity * option.price)),
      if (b.total != null) _Row(t.total, b.total == 0 ? t.free : formatPrice(lang, b.total!), strong: true),
      if (b.paymentMethod != null) _Row(t.paymentMethod, b.paymentMethod!),
      if (b.refundedAmount > 0) _Row(t.refund, formatPrice(lang, b.refundedAmount)),
      _Row(t.cancellation, b.policy),
      const SizedBox(height: 14),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (b.status.value == 'confirmee')
          OutlinePillButton(label: t.addToCalendar, icon: Icons.event_outlined, onPressed: () => launchUrl(Uri.parse(b.calendarUrl), mode: LaunchMode.externalApplication)),
        if (b.lat != null && b.lng != null)
          OutlinePillButton(label: t.directions, icon: Icons.directions_outlined, onPressed: () => launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${b.lat},${b.lng}'), mode: LaunchMode.externalApplication)),
        if (b.organizerPhone != null) OutlinePillButton(label: t.callOrganizer, icon: Icons.call_outlined, onPressed: () => launchUrl(Uri.parse('tel:${b.organizerPhone}'))),
        if (b.groupUrl != null) OutlinePillButton(label: t.groupShare, icon: Icons.group_outlined, onPressed: () => SharePlus.instance.share(ShareParams(text: b.groupUrl!))),
      ]),
      if (b.canCancel && !offline) ...[
        const SizedBox(height: 18),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: _busy ? null : () => _cancel(b),
            style: TextButton.styleFrom(foregroundColor: DowraColors.error),
            child: Text(t.cancelBooking, style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
        ),
      ] else if (b.isBuyer && b.status.value == 'confirmee') ...[
        const SizedBox(height: 14),
        Text(t.notCancellable, style: TextStyle(color: palette.muted, fontSize: 12.5)),
      ],
    ]);
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.color, required this.text, this.action});

  final Color color;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700, height: 1.4)),
          if (action != null) ...[const SizedBox(height: 12), action!],
        ]),
      );
}

class _TicketCard extends ConsumerWidget {
  const _TicketCard({required this.ticket, required this.canTransfer, required this.onTransfer});

  final Ticket ticket;
  final bool canTransfer;
  final VoidCallback onTransfer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final lang = ref.watch(localeProvider);
    final palette = context.palette;
    final color = switch (ticket.status.value) { 'valide' => DowraColors.success, 'utilise' => palette.accent, _ => DowraColors.error };
    return Opacity(
      opacity: ticket.status.value == 'annule' ? 0.5 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: palette.surface, borderRadius: BorderRadius.circular(26), border: Border.all(color: palette.line)),
        child: Column(children: [
          if (ticket.qr != null && ticket.status.value != 'annule')
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: QrImageView(data: ticket.qr!, size: 210, backgroundColor: Colors.white, semanticsLabel: 'QR ${ticket.code}'),
            ),
          const SizedBox(height: 10),
          Text(ticket.code, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          Text([ticket.type, if (ticket.holderName != null) ticket.holderName!].join(' · '), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(999)),
            child: Text(ticket.status.label, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
          if (ticket.scannedAt != null) Text(t.scannedOn(formatDateTime(lang, ticket.scannedAt!)), style: TextStyle(color: palette.muted, fontSize: 12)),
          if (ticket.transferredFrom != null) Text(t.transferredFrom(ticket.transferredFrom!), style: TextStyle(color: palette.muted, fontSize: 12)),
          if (ticket.claimUrl != null)
            TextButton.icon(onPressed: () => SharePlus.instance.share(ShareParams(text: ticket.claimUrl!)), icon: const Icon(Icons.share_outlined), label: Text(t.claimShare)),
          if (canTransfer) TextButton.icon(onPressed: onTransfer, icon: const Icon(Icons.send_outlined), label: Text(t.transferTicket)),
        ]),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.strong = false});

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Text(label, style: TextStyle(color: context.palette.muted))),
          const SizedBox(width: 12),
          Flexible(child: Text(value, textAlign: TextAlign.end, style: TextStyle(fontWeight: strong ? FontWeight.w800 : FontWeight.w600, fontSize: strong ? 18 : 14))),
        ]),
      );
}
