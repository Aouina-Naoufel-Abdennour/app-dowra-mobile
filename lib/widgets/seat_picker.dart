import 'package:flutter/material.dart';

import '../core/catalogue.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import 'buttons.dart';

/// Plan de salle (places numérotées) : une section par catégorie de billet, rang par rang.
/// Une place se choisit pour le billet actif ; les places prises sont grisées.
class SeatPicker extends StatelessWidget {
  const SeatPicker({super.key, required this.map, required this.tickets, required this.active, required this.onActive, required this.selected, required this.onToggle});

  final SeatMap map;
  final List<TicketInfo> tickets;
  final int active;
  final ValueChanged<int> onActive;
  final Map<int, List<String>> selected;
  final void Function(int ticketId, String seat) onToggle;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final palette = context.palette;
    final owner = {
      for (final entry in selected.entries)
        for (final seat in entry.value) seat: entry.key,
    };
    final activeTicket = tickets.firstWhere((ticket) => ticket.id == active, orElse: () => tickets.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.seatsHint, style: TextStyle(color: palette.muted, fontSize: 13)),
        if (tickets.length > 1) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final ticket in tickets)
                ChoicePill(label: '${ticket.name} · ${t.seatsChosen(selected[ticket.id]?.length ?? 0)}', selected: ticket.id == activeTicket.id, onTap: () => onActive(ticket.id)),
            ],
          ),
        ],
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: palette.soft,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: palette.line),
          ),
          child: Column(
            children: [
              Container(
                height: 6,
                width: 180,
                decoration: BoxDecoration(color: palette.line, borderRadius: BorderRadius.circular(6)),
              ),
              const SizedBox(height: 4),
              Text(
                t.stage.toUpperCase(),
                style: TextStyle(color: palette.muted, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Column(
                    children: [
                      for (final section in map.sections)
                        Opacity(
                          opacity: section.key == activeTicket.seatSection ? 1 : 0.45,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              children: [
                                Text(section.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                                const SizedBox(height: 6),
                                for (final row in section.rows)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 22,
                                          child: Text(
                                            row.label,
                                            style: TextStyle(color: palette.muted, fontSize: 11, fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        for (var number = 1; number <= row.seats; number++)
                                          _Seat(
                                            label: '${section.name}, ${row.label} $number',
                                            number: number,
                                            taken: map.taken.contains('${section.key}-${row.label}-$number'),
                                            mine: owner.containsKey('${section.key}-${row.label}-$number'),
                                            enabled: section.key == activeTicket.seatSection && (owner['${section.key}-${row.label}-$number'] ?? activeTicket.id) == activeTicket.id,
                                            onTap: () => onToggle(activeTicket.id, '${section.key}-${row.label}-$number'),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          children: [
            _Legend(color: palette.surface, border: palette.accent, label: t.seatFree),
            _Legend(color: palette.line, label: t.seatTaken),
            _Legend(color: palette.accent, label: t.seatMine),
          ],
        ),
      ],
    );
  }
}

class _Seat extends StatelessWidget {
  const _Seat({required this.label, required this.number, required this.taken, required this.mine, required this.enabled, required this.onTap});

  final String label;
  final int number;
  final bool taken;
  final bool mine;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final palette = context.palette;
    return Semantics(
      button: true,
      selected: mine,
      enabled: enabled && !taken,
      label:
          '$label · ${taken
              ? t.seatTaken
              : mine
              ? t.seatMine
              : t.seatFree}',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: enabled && !taken ? onTap : null,
        child: Container(
          width: 26,
          height: 26,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: mine ? palette.accent : (taken ? palette.line : palette.surface),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(9), bottom: Radius.circular(3)),
            border: mine || taken ? null : Border.all(color: palette.accent.withValues(alpha: 0.5)),
          ),
          child: Text(
            taken ? '' : '$number',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: mine ? Colors.white : palette.muted),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label, this.border});

  final Color color;
  final Color? border;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: border != null ? Border.all(color: border!.withValues(alpha: 0.5)) : null,
        ),
      ),
      const SizedBox(width: 6),
      Text(label, style: TextStyle(color: context.palette.muted, fontSize: 12)),
    ],
  );
}
