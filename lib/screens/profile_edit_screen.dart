import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../widgets/profile_form.dart';

/// Informations personnelles : prénom, e-mail, wilaya, envies.
class ProfileEditScreen extends ConsumerWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final user = ref.watch(sessionProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(t.personalInfo, style: const TextStyle(fontWeight: FontWeight.w800))),
      body: user == null
          ? const SizedBox.shrink()
          : SafeArea(
              top: false,
              child: ListView(padding: const EdgeInsets.fromLTRB(22, 8, 22, 32), children: [
                ProfileForm(
                  user: user,
                  submitLabel: t.save,
                  onSubmit: (fields) async {
                    await ref.read(sessionProvider.notifier).updateProfile(fields);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.saved)));
                      Navigator.of(context).maybePop();
                    }
                  },
                ),
              ]),
            ),
    );
  }
}
