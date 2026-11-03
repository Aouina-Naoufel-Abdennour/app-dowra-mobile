import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import 'brand.dart';
import 'buttons.dart';

/// Carte d'état vide ou d'invitation, toujours avec Dowri.
class DowriCard extends StatelessWidget {
  const DowriCard({super.key, required this.mood, required this.text, this.title, this.action});

  final DowriMood mood;
  final String? title;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: palette.surface, borderRadius: BorderRadius.circular(28), border: Border.all(color: palette.line)),
      child: Column(children: [
        Dowri(mood, size: 130),
        if (title != null) ...[
          const SizedBox(height: 8),
          Text(title!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        ],
        const SizedBox(height: 8),
        Text(text, textAlign: TextAlign.center, style: TextStyle(color: palette.muted, height: 1.5)),
        if (action != null) ...[const SizedBox(height: 18), action!],
      ]),
    );
  }
}

/// Onglet réservé aux comptes : invitation à se connecter pour un visiteur.
class GuestInvite extends StatelessWidget {
  const GuestInvite({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DowriCard(
      mood: DowriMood.salut,
      title: t.guestTitle,
      text: t.guestText,
      action: GradientButton(label: t.login, onPressed: () => context.push('/connexion')),
    );
  }
}

/// Message d'erreur réseau avec bouton pour réessayer.
class RetryCard extends StatelessWidget {
  const RetryCard({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DowriCard(
      mood: DowriMood.triste,
      text: t.networkError,
      action: OutlinePillButton(label: t.retry, icon: Icons.refresh_rounded, onPressed: onRetry),
    );
  }
}

/// Texte d'erreur de l'API (« network » → message traduit).
String errorText(BuildContext context, Object error) {
  final message = error.toString();
  return message == 'network' ? AppLocalizations.of(context).networkError : message;
}

/// En-tête de section : titre et lien « Tout voir ».
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800))),
      if (action != null)
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(foregroundColor: context.palette.accent, textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700)),
          child: Text(action!),
        ),
    ]);
  }
}

/// Pastille ronde d'une catégorie (couleur de l'API).
class CategoryDot extends StatelessWidget {
  const CategoryDot({super.key, required this.icon, required this.color, this.size = 30});

  final String? icon;
  final String? color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: DowraColors.fromHex(color), shape: BoxShape.circle),
        child: Icon(iconFor(icon), color: Colors.white, size: size * 0.56),
      );
}
