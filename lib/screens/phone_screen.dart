import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/demo.dart';
import '../core/phone.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../widgets/brand.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';

/// Connexion (écran 2a) : numéro de mobile, code envoyé par SMS.
class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _phone = TextEditingController(text: demoAccountsEnabled ? demoAccounts.first.phone : '');
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final t = AppLocalizations.of(context);
    final phone = normalizePhone(_phone.text);
    if (phone == null) {
      setState(() => _error = t.invalidPhone);
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      await ref.read(repositoryProvider).requestOtp(phone);
      if (mounted) context.push('/connexion/code', extra: phone);
    } catch (e) {
      if (mounted) setState(() => _error = errorText(context, e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final palette = context.palette;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: ListView(padding: const EdgeInsets.fromLTRB(22, 8, 22, 28), children: [
          const Align(alignment: AlignmentDirectional.centerStart, child: DowraLogo(size: 48, showWord: false)),
          const SizedBox(height: 22),
          BrandTitle(t.loginTitle, t.loginTitleEm, size: 32),
          const SizedBox(height: 10),
          Text(t.loginLead, style: TextStyle(color: palette.muted, height: 1.5)),
          const SizedBox(height: 26),
          Text(t.phoneLabel, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            textDirection: TextDirection.ltr,
            textAlign: locale == 'ar' ? TextAlign.end : TextAlign.start,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600, letterSpacing: 1),
            decoration: InputDecoration(hintText: t.phoneHint, errorText: _error, errorMaxLines: 3),
            onSubmitted: (_) => _send(),
          ),
          const SizedBox(height: 20),
          GradientButton(label: t.sendCode, loading: _loading, onPressed: _send),
          if (demoAccountsEnabled) ...[
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: palette.pale, borderRadius: BorderRadius.circular(22)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t.testAccounts, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final account in demoAccounts)
                    ChoicePill(
                      label: account.label(locale),
                      selected: _phone.text == account.phone,
                      onTap: () => setState(() => _phone.text = account.phone),
                    ),
                ]),
                const SizedBox(height: 10),
                Text(t.demoHint, style: TextStyle(color: palette.accent, fontSize: 13, height: 1.4)),
              ]),
            ),
          ],
          const SizedBox(height: 22),
          Text(t.terms, textAlign: TextAlign.center, style: TextStyle(color: palette.muted, fontSize: 12.5, height: 1.4)),
        ]),
      ),
    );
  }
}
