import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/catalogue.dart';
import '../core/catalogue_providers.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/event_card.dart';
import 'event_screen.dart';

/// Page organisateur : couverture, badge Vérifié, note, abonnement, sorties à venir, contact, signalement.
class OrganizerScreen extends ConsumerWidget {
  const OrganizerScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(organizerProvider(slug));
    return Scaffold(
      body: page.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const BackButton(), RetryCard(onRetry: () => ref.invalidate(organizerProvider(slug)))]))),
        data: (organizer) => _Body(organizer: organizer),
      ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.organizer});

  final OrganizerPage organizer;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  late bool _following = widget.organizer.isFollowing;
  late int _followers = widget.organizer.card.followersCount;

  Future<void> _toggle() async {
    if (ref.read(sessionProvider).value == null) {
      context.push('/connexion');
      return;
    }
    try {
      final result = await ref.read(repositoryProvider).setFollow(widget.organizer.card.slug, !_following);
      setState(() {
        _following = result.following;
        _followers = result.followers;
      });
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(context, error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final palette = context.palette;
    final o = widget.organizer;

    return CustomScrollView(slivers: [
      SliverAppBar(
        expandedHeight: 220,
        pinned: true,
        backgroundColor: DowraColors.mauve950,
        foregroundColor: Colors.white,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(fit: StackFit.expand, children: [
            EventCover(url: o.cover?.card),
            const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x331A0833), Color(0xE61A0833)]))),
          ]),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        sliver: SliverList.list(children: [
          Row(children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(gradient: DowraColors.gradient, borderRadius: BorderRadius.circular(18)),
              child: Text(o.card.name.substring(0, 1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Flexible(child: Text(o.card.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
                  if (o.card.verified) ...[const SizedBox(width: 6), Icon(Icons.verified, color: palette.accent, semanticLabel: t.verified)],
                ]),
                Text(
                  [if (o.wilayaName != null) o.wilayaName!, if (o.card.rating != null) '${o.card.rating} / 5 (${o.card.reviewsCount})', t.pastOutings(o.pastEventsCount)].join(' · '),
                  style: TextStyle(color: palette.muted, fontSize: 13),
                ),
              ]),
            ),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: _following
                  ? OutlinePillButton(label: t.following, icon: Icons.check_rounded, onPressed: _toggle)
                  : GradientButton(label: t.follow, onPressed: _toggle),
            ),
            const SizedBox(width: 12),
            Text(t.followersCount(_followers), style: TextStyle(color: palette.muted, fontWeight: FontWeight.w700)),
          ]),
          if (o.description != null) ...[
            const SizedBox(height: 20),
            Text(t.about, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(o.description!, style: TextStyle(height: 1.55, color: palette.muted)),
          ],
          const SizedBox(height: 22),
          Text(t.upcomingOutings, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          if (o.events.isEmpty)
            DowriCard(mood: DowriMood.repos, text: t.noUpcoming)
          else
            for (final event in o.events) Padding(padding: const EdgeInsets.only(bottom: 10), child: EventRowTile(event: event)),
          if (o.phone != null || o.email != null || o.socials.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(t.contact, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            if (o.phone != null) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.phone_outlined), title: Text(o.phone!, textDirection: TextDirection.ltr)),
            if (o.email != null) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.mail_outline), title: Text(o.email!)),
            for (final entry in o.socials.entries) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.public), title: Text('${entry.key} · ${entry.value}')),
          ],
          const SizedBox(height: 12),
          OutlinePillButton(label: t.reportOrganizer, icon: Icons.flag_outlined, onPressed: () => showReportSheet(context, ref, type: 'organizer', slug: o.card.slug, title: t.reportOrganizer)),
        ]),
      ),
    ]);
  }
}
