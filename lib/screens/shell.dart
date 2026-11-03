import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../theme/colors.dart';

/// Gabarit des 5 onglets : barre de navigation flottante sombre, onglet actif en pilule dégradée.
class DowraShell extends StatelessWidget {
  const DowraShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final tabs = [
      (Icons.home_rounded, t.navHome),
      (Icons.search_rounded, t.navExplore),
      (Icons.confirmation_number_outlined, t.navTickets),
      (Icons.favorite_border_rounded, t.navFavorites),
      (Icons.person_outline_rounded, t.navProfile),
    ];

    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: Container(
          height: 66,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: DowraColors.ink,
            borderRadius: BorderRadius.circular(999),
            boxShadow: const [BoxShadow(color: Color(0x401A0833), blurRadius: 30, offset: Offset(0, 12))],
          ),
          child: Row(children: [
            for (var i = 0; i < tabs.length; i++)
              Expanded(
                flex: i == shell.currentIndex ? 2 : 1,
                child: _Tab(
                  icon: tabs[i].$1,
                  label: tabs[i].$2,
                  selected: i == shell.currentIndex,
                  onTap: () => shell.goBranch(i, initialLocation: i == shell.currentIndex),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(gradient: selected ? DowraColors.gradient : null, borderRadius: BorderRadius.circular(999)),
          child: selected
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                  Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13))),
                ])
              : Icon(icon, color: const Color(0xFFB7AEC4), size: 22),
        ),
      ),
    );
  }
}
