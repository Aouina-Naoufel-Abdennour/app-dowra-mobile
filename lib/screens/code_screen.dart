import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// Connexion (écran 2b) : code à 6 chiffres reçu par SMS ; la session s'ouvre et l'app continue seule.
class CodeScreen extends ConsumerStatefulWidget {
  const CodeScreen({super.key, required this.phone});

  final String phone;

  @override
  ConsumerState<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends ConsumerState<CodeScreen> {
  final _code = TextEditingController(text: demoAccountsEnabled ? demoCode : '');
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      final device = kIsWeb ? 'app-web' : 'app-${defaultTargetPlatform.name}';
      final user = await ref.read(repositoryProvider).verifyOtp(widget.phone, _code.text.trim(), deviceName: device);
      ref.read(sessionProvider.notifier).signedIn(user);
      // Accueil, ou premier passage chez Dowri pour un nouveau compte (les écrans de connexion sont refermés).
      if (mounted) context.go(user.onboarded ? '/accueil' : '/premiers-pas');
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

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: ListView(padding: const EdgeInsets.fromLTRB(22, 8, 22, 28), children: [
          const Align(alignment: AlignmentDirectional.centerStart, child: DowraLogo(size: 48, showWord: false)),
          const SizedBox(height: 22),
          BrandTitle(t.codeTitle, t.codeTitleEm, size: 32),
          const SizedBox(height: 10),
          // Numéro isolé (U+2066…U+2069) pour garder l'ordre des chiffres dans une phrase en arabe.
          Text(t.codeSentTo('\u2066${formatPhone(widget.phone)}\u2069'), style: TextStyle(color: palette.muted, height: 1.5)),
          const SizedBox(height: 26),
          TextField(
            controller: _code,
            autofocus: !demoAccountsEnabled,
            keyboardType: TextInputType.number,
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: 14),
            decoration: InputDecoration(hintText: '••••••', errorText: _error, errorMaxLines: 3),
            onSubmitted: (_) => _verify(),
          ),
          const SizedBox(height: 20),
          GradientButton(label: t.verify, loading: _loading, onPressed: _verify),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              style: TextButton.styleFrom(foregroundColor: palette.accent, textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700)),
              child: Text(t.changeNumber),
            ),
          ),
          if (demoAccountsEnabled) ...[
            const SizedBox(height: 8),
            Text(t.demoHint, textAlign: TextAlign.center, style: TextStyle(color: palette.accent, fontSize: 13)),
          ],
          const SizedBox(height: 16),
          const Center(child: Dowri(DowriMood.billet, size: 110)),
        ]),
      ),
    );
  }
}
