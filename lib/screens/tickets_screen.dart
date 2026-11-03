import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/booking_providers.dart';
import '../core/bookings.dart';
import '../core/format.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';

/// Mes billets (écran 10) : à venir et passés, gardés sur le téléphone pour être vus sans réseau.
class TicketsScreen extends ConsumerStatefulWidget {
  const TicketsScreen({super.key});

  @override
  ConsumerState<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends ConsumerState<TicketsScreen> {
  String _scope = 'upcoming';

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final signedIn = ref.watch(sessionProvider).value != null;
    final bookings = ref.watch(bookingsProvider(_scope));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(bookingsProvider(_scope)),
        child: ListView(padding: EdgeInsets.fromLTRB(20, MediaQuery.paddingOf(context).top + 14, 20, 120), children: [
          BrandTitle(t.ticketsTitle, t.ticketsTitleEm, size: 30),
          const SizedBox(height: 16),
          if (!signedIn)
            const GuestInvite()
          else ...[
            Wrap(spacing: 8, children: [
              ChoicePill(label: t.ticketsUpcoming, selected: _scope == 'upcoming', onTap: () => setState(() => _scope = 'upcoming')),
              ChoicePill(label: t.ticketsPast, selected: _scope == 'past', onTap: () => setState(() => _scope = 'past')),
            ]),
            const SizedBox(height: 16),
            bookings.when(
              loading: () => const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator())),
              error: (_, _) => RetryCard(onRetry: () => ref.invalidate(bookingsProvider(_scope))),
              data: (result) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (result.offline) const OfflineBanner(),
                if (result.bookings.isEmpty)
                  DowriCard(
                    mood: DowriMood.billet,
                    text: _scope == 'past' ? t.ticketsEmptyPast : t.ticketsEmpty,
                    action: _scope == 'upcoming' ? GradientButton(label: t.findOuting, onPressed: () => context.go('/explorer')) : null,
                  )
                else
                  for (final booking in result.bookings) Padding(padding: const EdgeInsets.only(bottom: 10), child: BookingTile(booking: booking)),
              ]),
            ),
          ],
        ]),
      ),
    );
  }
}

/// Bandeau « hors connexion » : l'écran affiche la copie gardée sur le téléphone.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: DowraColors.sun.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          const Icon(Icons.cloud_off_rounded, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(AppLocalizations.of(context).offlineCopy, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        ]),
      );
}

Color statusColor(String status) => switch (status) {
      'confirmee' => DowraColors.success,
      'bloquee' || 'en_attente' => DowraColors.warning,
      'annulee' || 'refusee' => DowraColors.error,
      _ => Colors.grey,
    };

class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});

  final Label status;

  @override
  Widget build(BuildContext context) {
    final color = statusColor(status.value);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(999)),
      child: Text(status.label, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 11.5)),
    );
  }
}

class BookingTile extends ConsumerWidget {
  const BookingTile({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final lang = ref.watch(localeProvider);
    final palette = context.palette;
    final issued = booking.myTickets.where((ticket) => ticket.status.value != 'annule').length;
    final mine = booking.tickets.isEmpty ? booking.items.fold(0, (sum, item) => sum + item.quantity) : issued;
    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: BorderSide(color: palette.line)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/billets/${booking.code}'),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 84,
                height: 84,
                child: booking.cover == null
                    ? const DecoratedBox(decoration: BoxDecoration(gradient: DowraColors.gradient), child: Icon(Icons.confirmation_number_outlined, color: Colors.white))
                    : CachedNetworkImage(imageUrl: booking.cover!.thumb, fit: BoxFit.cover, errorWidget: (_, _, _) => ColoredBox(color: palette.pale)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Flexible(child: StatusChip(booking.status)),
                  const SizedBox(width: 6),
                  Text(booking.code, style: TextStyle(color: palette.muted, fontSize: 11.5, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 4),
                Text(booking.eventTitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                Text(formatDateTime(lang, booking.startsAt), style: TextStyle(color: palette.muted, fontSize: 12.5)),
                const SizedBox(height: 2),
                Text(t.ticketsCount(mine), style: TextStyle(color: palette.accent, fontWeight: FontWeight.w700, fontSize: 12.5)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
