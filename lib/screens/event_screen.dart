import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/catalogue.dart';
import '../core/catalogue_providers.dart';
import '../core/format.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../l10n/labels.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/event_card.dart';
import '../widgets/events_map.dart';

/// Fiche sortie (écran 6) : photos, infos, organisateur, séances, billets, lieu, météo, favori, partage, signalement.
class EventScreen extends ConsumerWidget {
  const EventScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventProvider(slug));
    return Scaffold(
      body: event.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const BackButton(), RetryCard(onRetry: () => ref.invalidate(eventProvider(slug)))]))),
        data: (event) => _EventBody(event: event),
      ),
    );
  }
}

class _EventBody extends ConsumerStatefulWidget {
  const _EventBody({required this.event});

  final EventDetail event;

  @override
  ConsumerState<_EventBody> createState() => _EventBodyState();
}

class _EventBodyState extends ConsumerState<_EventBody> {
  late bool _favorite = widget.event.isFavorite;
  int _photo = 0;

  EventDetail get e => widget.event;

  Future<void> _toggleFavorite() async {
    final t = AppLocalizations.of(context);
    if (ref.read(sessionProvider).value == null) {
      context.push('/connexion');
      return;
    }
    final next = !_favorite;
    setState(() => _favorite = next);
    try {
      final result = await ref.read(repositoryProvider).setFavorite(e.card.slug, next);
      ref.invalidate(favoritesProvider);
      if (mounted) {
        setState(() => _favorite = result);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result ? t.favoriteAdded : t.favoriteRemoved)));
      }
    } catch (error) {
      if (mounted) {
        setState(() => _favorite = !next);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(context, error))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = ref.watch(localeProvider);
    final palette = context.palette;
    final photos = e.photos.isEmpty && e.card.cover != null ? [e.card.cover!] : e.photos;
    final fieldLabels = typeFieldLabels[lang] ?? typeFieldLabels['fr']!;
    final coordinates = e.card.lat != null && e.card.lng != null ? (e.card.lat!, e.card.lng!) : null;

    return CustomScrollView(slivers: [
      SliverAppBar(
        expandedHeight: 320,
        pinned: true,
        backgroundColor: palette.background,
        leading: _RoundButton(icon: Icons.arrow_back_rounded, onTap: () => context.pop(), tooltip: MaterialLocalizations.of(context).backButtonTooltip),
        actions: [
          _RoundButton(icon: Icons.ios_share_rounded, tooltip: t.share, onTap: () => SharePlus.instance.share(ShareParams(text: '${e.card.title}\n${e.shareUrl}'))),
          _RoundButton(icon: _favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, tooltip: t.navFavorites, color: _favorite ? DowraColors.rose : null, onTap: _toggleFavorite),
          const SizedBox(width: 8),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(fit: StackFit.expand, children: [
            if (photos.isEmpty)
              EventCover(url: null, icon: e.card.typeIcon)
            else
              PageView.builder(
                itemCount: photos.length,
                onPageChanged: (i) => setState(() => _photo = i),
                itemBuilder: (_, i) => EventCover(url: photos[i].full),
              ),
            if (photos.length > 1)
              PositionedDirectional(
                bottom: 14,
                end: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(999)),
                  child: Text('${_photo + 1} / ${photos.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ),
          ]),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
        sliver: SliverList.list(children: [
          if (e.card.status == 'annule' || e.card.status == 'termine')
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: DowraColors.sun.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(14)),
              child: Text(e.card.status == 'annule' ? t.cancelledEvent : t.endedEvent, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          Wrap(spacing: 6, runSpacing: 6, children: [
            if (e.card.labels.featured) PhotoBadge(t.badgeFeatured, sun: true),
            if (e.card.labels.hiddenGem) PhotoBadge(t.badgeGem),
            if (e.card.labels.wilayaOfDay) PhotoBadge(t.wilayaOfDay),
          ]),
          const SizedBox(height: 10),
          Text(e.card.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 8),
          Row(children: [
            Icon(iconFor(e.card.typeIcon), size: 17, color: palette.accent),
            const SizedBox(width: 6),
            Expanded(child: Text([e.card.typeName, ...e.categories].join(' · '), style: TextStyle(color: palette.accent, fontWeight: FontWeight.w700, fontSize: 13))),
          ]),
          const SizedBox(height: 16),
          _OrganizerTile(organizer: e.organizer),
          const SizedBox(height: 16),
          Row(children: [
            _Fact(icon: Icons.event_rounded, title: e.card.nextSessionAt == null ? '—' : formatLongDay(lang, e.card.nextSessionAt!), subtitle: e.card.nextSessionAt == null ? '' : formatTime(e.card.nextSessionAt!)),
            const SizedBox(width: 10),
            _Fact(icon: Icons.place_outlined, title: e.card.wilayaName, subtitle: e.venueName ?? e.meetingPoint ?? ''),
          ]),
          if (e.card.summary != null) ...[const SizedBox(height: 18), Text(e.card.summary!, style: TextStyle(fontSize: 16, height: 1.55, color: palette.muted))],
          if (e.description != null && e.description != e.card.summary) ...[const SizedBox(height: 12), Text(e.description!, style: const TextStyle(fontSize: 15.5, height: 1.6))],
          if (e.weather != null) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: palette.pale, borderRadius: BorderRadius.circular(18)),
              child: Row(children: [
                Icon(_weatherIcon(e.weather!.icon), color: palette.accent, size: 34),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${t.weatherForecast} · ${e.weather!.label}, ${e.weather!.tempMin.round()}° / ${e.weather!.tempMax.round()}°${e.weather!.rainChance != null ? ' · ${t.rainChance(e.weather!.rainChance!)}' : ''}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
            ),
          ],
          _Section(title: t.sessions),
          if (e.sessions.isEmpty)
            Text(t.noSessions, style: TextStyle(color: palette.muted))
          else
            for (final session in e.sessions)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: palette.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: palette.line)),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(formatLongDay(lang, session.startsAt), style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text([formatTime(session.startsAt), if (session.label != null) session.label!].join(' · '), style: TextStyle(color: palette.muted, fontSize: 13)),
                    ]),
                  ),
                  if (session.capacity != null) Text(t.placesCount(session.remaining ?? session.capacity!), style: TextStyle(color: palette.muted, fontSize: 12, fontWeight: FontWeight.w700)),
                ]),
              ),
          if (e.sessions.isNotEmpty && e.sessions.first.pickupPoints.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(t.pickups, style: const TextStyle(fontWeight: FontWeight.w800)),
            for (final point in e.sessions.first.pickupPoints) Text('${point.time != null ? '${point.time} · ' : ''}${point.label}', style: TextStyle(color: palette.muted)),
          ],
          _Section(title: t.tickets),
          for (final ticket in e.tickets)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(ticket.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    if (ticket.seats > 1) Text(t.placesCount(ticket.seats), style: TextStyle(color: palette.muted, fontSize: 12)),
                  ]),
                ),
                Text(ticket.price == 0 ? t.free : formatPrice(lang, ticket.price), style: const TextStyle(fontWeight: FontWeight.w800)),
              ]),
            ),
          const SizedBox(height: 8),
          Text('${t.saleMode} : ${e.saleMode}\n${t.cancellation} : ${e.cancellationPolicy}\n${t.maxPerPerson(e.maxPerPerson)}', style: TextStyle(color: palette.muted, fontSize: 13, height: 1.5)),
          if (e.typeFields.isNotEmpty || e.ageMin != null) ...[
            _Section(title: t.details),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final entry in e.typeFields.entries) _InfoChip(label: fieldLabels[entry.key] ?? entry.key, value: entry.value),
              if (e.ageMin != null) _InfoChip(label: fieldLabels['age_minimum']!, value: t.ageMin(e.ageMin!)),
            ]),
          ],
          if (e.program.isNotEmpty) ...[
            _Section(title: t.program),
            for (final (index, step) in e.program.indexed)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(backgroundColor: DowraColors.mauve600, foregroundColor: Colors.white, child: Text('${index + 1}')),
                title: Text(step.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text([step.day, if (step.text != null) step.text!].join(' · ')),
              ),
          ],
          if (e.includes.isNotEmpty) ...[
            _Section(title: t.includes),
            for (final item in e.includes)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(children: [const Icon(Icons.check_rounded, color: DowraColors.success, size: 20), const SizedBox(width: 8), Expanded(child: Text(item))]),
              ),
          ],
          _Section(title: e.venueName != null ? t.place : t.meetingPoint),
          Text(e.venueName ?? e.meetingPoint ?? e.card.wilayaName, style: const TextStyle(fontWeight: FontWeight.w700)),
          Text([e.venueAddress, e.commune, e.card.wilayaName].whereType<String>().join(', '), style: TextStyle(color: palette.muted)),
          if (coordinates != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(height: 180, child: EventsMap(interactive: false, pins: [MapPin(lat: coordinates.$1, lng: coordinates.$2, label: e.venueName ?? e.card.title)])),
            ),
            TextButton.icon(
              onPressed: () => launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${coordinates.$1},${coordinates.$2}'), mode: LaunchMode.externalApplication),
              icon: const Icon(Icons.directions_rounded),
              label: Text(t.directions),
            ),
          ],
          const SizedBox(height: 16),
          OutlinePillButton(label: t.report, icon: Icons.flag_outlined, onPressed: () => showReportSheet(context, ref, type: 'event', slug: e.card.slug, title: t.reportTitle)),
          _Similar(slug: e.card.slug),
        ]),
      ),
    ]);
  }

  IconData _weatherIcon(String icon) => switch (icon) {
        'sun' => Icons.wb_sunny_outlined,
        'cloud' => Icons.cloud_outlined,
        'rain' => Icons.water_drop_outlined,
        'snow' => Icons.ac_unit_rounded,
        'storm' => Icons.thunderstorm_outlined,
        _ => Icons.foggy,
      };
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap, required this.tooltip, this.color});

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(6),
        child: Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: IconButton(icon: Icon(icon, color: color ?? DowraColors.ink, size: 21), tooltip: tooltip, onPressed: onTap),
        ),
      );
}

class _Section extends StatelessWidget {
  const _Section({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(top: 26, bottom: 10), child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)));
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: palette.pale, borderRadius: BorderRadius.circular(16)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 20, color: palette.accent),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
              if (subtitle.isNotEmpty) Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: palette.muted, fontSize: 12)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      constraints: const BoxConstraints(minWidth: 140),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: palette.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: palette.line)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: TextStyle(color: palette.muted, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class _OrganizerTile extends StatelessWidget {
  const _OrganizerTile({required this.organizer});

  final OrganizerCard organizer;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final palette = context.palette;
    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: palette.line)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        onTap: () => context.push('/organisateurs/${organizer.slug}'),
        leading: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(gradient: DowraColors.gradient, borderRadius: BorderRadius.circular(14)),
          child: Text(organizer.name.substring(0, 1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        ),
        title: Row(children: [
          Flexible(child: Text(organizer.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800))),
          if (organizer.verified) ...[const SizedBox(width: 4), Icon(Icons.verified, size: 18, color: palette.accent, semanticLabel: t.verified)],
        ]),
        subtitle: Text([if (organizer.rating != null) '${organizer.rating} / 5 (${organizer.reviewsCount})', t.followersCount(organizer.followersCount)].join(' · ')),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _Similar extends ConsumerWidget {
  const _Similar({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final similar = ref.watch(similarProvider(slug)).value ?? const [];
    if (similar.isEmpty) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(top: 28), child: EventSection(title: t.similar, events: similar));
  }
}

/// Feuille « Signaler » : motif et précisions ; connexion demandée à un visiteur.
Future<void> showReportSheet(BuildContext context, WidgetRef ref, {required String type, required String slug, required String title}) async {
  if (ref.read(sessionProvider).value == null) {
    context.push('/connexion');
    return;
  }
  final t = AppLocalizations.of(context);
  final lang = ref.read(localeProvider);
  final reasons = reportReasonLabels[lang] ?? reportReasonLabels['fr']!;
  var reason = reasons.keys.first;
  final details = TextEditingController();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheet) => StatefulBuilder(
      builder: (sheet, setState) => Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.viewInsetsOf(sheet).bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text(t.reportReason, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final entry in reasons.entries) ChoicePill(label: entry.value, selected: reason == entry.key, onTap: () => setState(() => reason = entry.key)),
          ]),
          const SizedBox(height: 14),
          TextField(controller: details, maxLines: 3, maxLength: 1000, decoration: InputDecoration(hintText: t.reportDetails)),
          const SizedBox(height: 8),
          GradientButton(
            label: t.reportSend,
            onPressed: () async {
              try {
                await ref.read(repositoryProvider).report(type: type, slug: slug, reason: reason, details: details.text.trim());
                if (sheet.mounted) Navigator.of(sheet).pop();
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.reportSent)));
              } catch (error) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(context, error))));
              }
            },
          ),
        ]),
      ),
    ),
  );
  details.dispose();
}
