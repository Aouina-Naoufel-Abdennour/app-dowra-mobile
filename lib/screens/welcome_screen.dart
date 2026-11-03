import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/buttons.dart';

/// Bienvenue (écran 1) : photo plein écran, choix de la langue, Dowri, commencer ou se connecter.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final arabic = locale == 'ar';

    void start(String path) {
      ref.read(introSeenProvider.notifier).markSeen();
      if (path == '/connexion') {
        context.go('/accueil');
        context.push('/connexion');
      } else {
        context.go(path);
      }
    }

    return Scaffold(
      backgroundColor: DowraColors.mauve950,
      body: Stack(fit: StackFit.expand, children: [
        Image.asset('assets/photos/h-taghit.jpg', fit: BoxFit.cover, semanticLabel: 'Taghit'),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.3, 0.55, 1],
              colors: [Color(0x991A0833), Color(0x001A0833), Color(0xB31A0833), Color(0xF21A0833)],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const DowraLogo(size: 34, color: Colors.white),
                const Spacer(),
                _LanguageChips(current: locale, onChanged: ref.read(localeProvider.notifier).set),
              ]),
              const Spacer(),
              const Align(alignment: AlignmentDirectional.centerEnd, child: Dowri(DowriMood.salut, size: 120)),
              Transform.rotate(
                angle: -0.05,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 6, 14, 5),
                  decoration: BoxDecoration(color: DowraColors.sun, borderRadius: BorderRadius.circular(999)),
                  child: Text(t.welcomeKicker,
                      style: TextStyle(fontFamily: arabic ? 'NotoKufiArabic' : 'Caveat', fontSize: arabic ? 15 : 24, fontWeight: FontWeight.w700, color: DowraColors.ink)),
                ),
              ),
              const SizedBox(height: 14),
              Text(t.welcomeTitle,
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white, height: arabic ? 1.4 : 1.08, letterSpacing: arabic ? 0 : -1)),
              const SizedBox(height: 12),
              Text(t.welcomeLead, style: const TextStyle(fontSize: 15.5, color: Color(0xE6FFFFFF), height: 1.5)),
              const SizedBox(height: 26),
              GradientButton(label: t.start, onPressed: () => start('/accueil')),
              const SizedBox(height: 12),
              OutlinePillButton(label: t.haveAccount, onPressed: () => start('/connexion'), color: const Color(0x66FFFFFF), foreground: Colors.white),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _LanguageChips extends StatelessWidget {
  const _LanguageChips({required this.current, required this.onChanged});

  final String current;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const short = {'fr': 'FR', 'ar': 'عربي', 'en': 'EN'};
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0x26FFFFFF), borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0x40FFFFFF))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        for (final code in supportedLocales)
          Semantics(
            selected: code == current,
            button: true,
            label: localeLabels[code],
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onChanged(code),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(color: code == current ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(999)),
                child: Text(short[code]!,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: code == current ? DowraColors.mauve600 : Colors.white)),
              ),
            ),
          ),
      ]),
    );
  }
}
