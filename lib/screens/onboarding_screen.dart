import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../router.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/profile_form.dart';

/// Premier passage après l'inscription : Dowri fait connaissance (prénom, wilaya, envies).
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final user = ref.watch(sessionProvider).value;
    if (user == null) return const Scaffold();

    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.fromLTRB(22, 16, 22, 32), children: [
          Row(children: [
            const DowraLogo(size: 32),
            const Spacer(),
            TextButton(
              onPressed: () {
                ref.read(onboardingPostponedProvider.notifier).postpone();
                context.go('/accueil');
              },
              style: TextButton.styleFrom(foregroundColor: context.palette.muted, textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700)),
              child: Text(t.later),
            ),
          ]),
          const SizedBox(height: 18),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                HandTag(t.onboardingKicker),
                const SizedBox(height: 12),
                BrandTitle(t.onboardingTitle, t.onboardingTitleEm, size: 30),
              ]),
            ),
            const Dowri(DowriMood.salut, size: 110),
          ]),
          const SizedBox(height: 10),
          Text(t.onboardingLead, style: TextStyle(color: context.palette.muted, height: 1.5)),
          const SizedBox(height: 26),
          ProfileForm(
            user: user,
            onboarding: true,
            submitLabel: t.discover,
            onSubmit: (fields) async {
              await ref.read(sessionProvider.notifier).updateProfile({...fields, 'onboarded': true});
              if (context.mounted) context.go('/accueil');
            },
          ),
        ]),
      ),
    );
  }
}
