import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/catalogue.dart';
import '../core/format.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import 'brand.dart';

/// Photo d'une sortie ; dégradé avec le pictogramme du type quand il n'y a pas de photo.
class EventCover extends StatelessWidget {
  const EventCover({super.key, required this.url, this.icon, this.fit = BoxFit.cover});

  final String? url;
  final String? icon;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final placeholder = DecoratedBox(
      decoration: const BoxDecoration(gradient: DowraColors.gradient),
      child: Center(child: Icon(iconFor(icon), color: Colors.white, size: 40)),
    );
    if (url == null) return placeholder;
    return CachedNetworkImage(
      imageUrl: url!,
      fit: fit,
      placeholder: (_, _) => ColoredBox(color: context.palette.pale),
      errorWidget: (_, _, _) => placeholder,
    );
  }
}

/// Pastille de label sur une photo (À la une, Trésor caché).
class PhotoBadge extends StatelessWidget {
  const PhotoBadge(this.text, {super.key, this.sun = false});

  final String text;
  final bool sun;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(color: sun ? DowraColors.sun : null, gradient: sun ? null : DowraColors.gradient, borderRadius: BorderRadius.circular(999)),
    child: Text(
      text,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: sun ? DowraColors.ink : Colors.white),
    ),
  );
}

String priceLabel(BuildContext context, String lang, EventCard event) {
  final t = AppLocalizations.of(context);
  if (event.isFree) return t.free;
  if (event.priceFrom == null) return '';
  return t.priceFrom(formatPrice(lang, event.priceFrom!));
}

/// Carte verticale (rangées de l'accueil, favoris, page organisateur).
class EventTile extends ConsumerWidget {
  const EventTile({super.key, required this.event, this.width = 250});

  final EventCard event;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final lang = ref.watch(localeProvider);
    final palette = context.palette;

    return SizedBox(
      width: width,
      child: Material(
        color: palette.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: palette.line),
        ),
        child: InkWell(
          onTap: () => context.push('/sorties/${event.slug}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 11,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    EventCover(url: event.cover?.card, icon: event.typeIcon),
                    PositionedDirectional(
                      top: 10,
                      start: 10,
                      child: Wrap(
                        spacing: 6,
                        children: [if (event.labels.featured) PhotoBadge(t.badgeFeatured, sun: true), if (event.labels.hiddenGem) PhotoBadge(t.badgeGem)],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (event.nextSessionAt != null)
                        Text(
                          formatDateTime(lang, event.nextSessionAt!).toUpperCase(),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: palette.accent, letterSpacing: 0.3),
                        ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          event.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5, height: 1.25),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.place_outlined, size: 15, color: palette.muted),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              [event.place, event.wilayaName].whereType<String>().join(' · '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12.5, color: palette.muted),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(priceLabel(context, lang, event), maxLines: 1, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Carte horizontale (liste d'Explorer, comme la maquette 4).
class EventRowTile extends ConsumerWidget {
  const EventRowTile({super.key, required this.event});

  final EventCard event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final lang = ref.watch(localeProvider);
    final palette = context.palette;

    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: palette.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/sorties/${event.slug}'),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 104,
                  height: 104,
                  child: EventCover(url: event.cover?.thumb, icon: event.typeIcon),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.organizerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: palette.muted, fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (event.organizerVerified) Icon(Icons.verified, size: 15, color: palette.accent, semanticLabel: t.verified),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, height: 1.25),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        if (event.nextSessionAt != null) formatDateTime(lang, event.nextSessionAt!),
                        event.wilayaName,
                        if (event.distanceKm != null) t.distanceKm('${event.distanceKm}'),
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.5, color: palette.muted),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          priceLabel(context, lang, event),
                          style: TextStyle(fontWeight: FontWeight.w800, color: palette.accent),
                        ),
                        const Spacer(),
                        if (event.labels.hiddenGem) PhotoBadge(t.badgeGem),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rangée défilante de cartes avec titre et « Tout voir ».
class EventSection extends StatelessWidget {
  const EventSection({super.key, required this.title, required this.events, this.onSeeAll});

  final String title;
  final List<EventCard> events;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();
    final t = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            ),
            if (onSeeAll != null)
              TextButton(
                onPressed: onSeeAll,
                style: TextButton.styleFrom(
                  foregroundColor: context.palette.accent,
                  textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700),
                ),
                child: Text(t.seeAll),
              ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: events.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) => EventTile(event: events[i]),
          ),
        ),
      ],
    );
  }
}
