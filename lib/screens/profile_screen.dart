import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/api.dart';
import '../core/phone.dart';
import '../core/booking_providers.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';

/// Profil et passeport (écran 14) : niveau et points, informations, langue, affichage, déconnexion, suppression.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final palette = context.palette;
    final user = ref.watch(sessionProvider).value;
    final locale = ref.watch(localeProvider);
    final mode = ref.watch(themeModeProvider);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(20, MediaQuery.paddingOf(context).top + 14, 20, 120),
        children: [
          BrandTitle(t.profileTitle, t.profileTitleEm, size: 30),
          const SizedBox(height: 18),
          if (user == null)
            const GuestInvite()
          else ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(gradient: DowraColors.gradient, borderRadius: BorderRadius.circular(26)),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: DowraColors.sun, borderRadius: BorderRadius.circular(18)),
                    child: Text(
                      user.initials,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: DowraColors.ink),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name ?? formatPhone(user.phone),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                        const SizedBox(height: 2),
                        Text('${t.level} ${user.levelLabel} · ${t.points(user.points)}', style: const TextStyle(color: Color(0xE6FFFFFF), fontSize: 13)),
                        if (user.isAmbassador) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(color: DowraColors.sun, borderRadius: BorderRadius.circular(999)),
                            child: Text(
                              t.ambassador,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5, color: DowraColors.ink),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _Tile(icon: Icons.person_outline_rounded, label: t.personalInfo, onTap: () => context.push('/profil/infos')),
            const SizedBox(height: 8),
            _Tile(icon: Icons.card_giftcard_rounded, label: t.giftCards, onTap: () => context.push('/cartes-cadeaux')),
            if (user.roles.any(scanRoles.contains)) ...[const SizedBox(height: 8), _Tile(icon: Icons.qr_code_scanner_rounded, label: t.scanMode, onTap: () => context.push('/scan'))],
            const SizedBox(height: 8),
            _Tile(
              icon: Icons.campaign_outlined,
              label: t.organizerSpace,
              subtitle: t.organizerSpaceHint,
              onTap: () => launchUrl(Uri.parse('${defaultSiteUrl()}/${ref.read(localeProvider)}/pro'), mode: LaunchMode.externalApplication),
            ),
          ],
          const SizedBox(height: 22),
          Text(t.language, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final code in supportedLocales) ChoicePill(label: localeLabels[code]!, selected: locale == code, onTap: () => ref.read(localeProvider.notifier).set(code))],
          ),
          const SizedBox(height: 22),
          Text(t.display, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (value, label, icon) in [
                ('clair', t.themeLight, Icons.light_mode_outlined),
                ('sombre', t.themeDark, Icons.dark_mode_outlined),
                ('systeme', t.themeSystem, Icons.phone_android_outlined),
              ])
                ChoicePill(
                  label: label,
                  selected: mode == value,
                  leading: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: Icon(icon, size: 18, color: mode == value ? Colors.white : palette.accent),
                  ),
                  onTap: () => ref.read(themeModeProvider.notifier).set(value),
                ),
            ],
          ),
          if (user != null) ...[
            const SizedBox(height: 28),
            OutlinePillButton(label: t.logout, icon: Icons.logout_rounded, onPressed: () => ref.read(sessionProvider.notifier).logout()),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => _confirmDelete(context, ref),
                style: TextButton.styleFrom(
                  foregroundColor: DowraColors.error,
                  textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700),
                ),
                child: Text(t.deleteAccount),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final t = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        icon: const Dowri(DowriMood.triste, size: 90),
        title: Text(t.deleteConfirmTitle),
        content: Text(t.deleteConfirmText),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialog, false), child: Text(t.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: DowraColors.error),
            onPressed: () => Navigator.pop(dialog, true),
            child: Text(t.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(sessionProvider.notifier).deleteAccount();
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(context, e))));
    }
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label, required this.onTap, this.subtitle});

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: palette.line),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: Icon(icon, color: palette.accent),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: subtitle != null ? Text(subtitle!, style: TextStyle(color: palette.muted, fontSize: 12.5)) : null,
        trailing: Icon(Icons.chevron_right_rounded, color: palette.muted),
        onTap: onTap,
      ),
    );
  }
}
