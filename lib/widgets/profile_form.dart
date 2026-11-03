import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import 'buttons.dart';
import 'common.dart';

/// Champs du profil envoyés à PATCH /me : prénom, (e-mail), wilaya de départ, envies.
/// Partagé par le premier passage chez Dowri et « Informations personnelles ».
class ProfileForm extends ConsumerStatefulWidget {
  const ProfileForm({super.key, required this.user, required this.submitLabel, required this.onSubmit, this.onboarding = false});

  final DowraUser user;
  final String submitLabel;
  final bool onboarding;
  final Future<void> Function(Map<String, Object?> fields) onSubmit;

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  late final _name = TextEditingController(text: widget.user.name ?? '');
  late final _email = TextEditingController(text: widget.user.email ?? '');
  late int? _wilayaId = widget.user.wilayaId;
  late final Set<String> _interests = {...widget.user.interests};
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _saving = true;
    });
    try {
      await widget.onSubmit({
        'name': _name.text.trim().isEmpty ? null : _name.text.trim(),
        if (!widget.onboarding) 'email': _email.text.trim().isEmpty ? null : _email.text.trim(),
        'wilaya_id': _wilayaId,
        'interests': _interests.toList(),
      });
    } catch (e) {
      if (mounted) setState(() => _error = errorText(context, e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final palette = context.palette;
    final wilayas = ref.watch(wilayasProvider);
    final categories = ref.watch(categoriesProvider);
    final label = TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: palette.text);

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(widget.onboarding ? t.nameQuestion : t.name, style: label),
      const SizedBox(height: 8),
      TextField(controller: _name, maxLength: 80, textCapitalization: TextCapitalization.words, autofillHints: const [AutofillHints.name], decoration: const InputDecoration(counterText: '')),
      if (!widget.onboarding) ...[
        const SizedBox(height: 18),
        Text(t.email, style: label),
        const SizedBox(height: 8),
        TextField(controller: _email, keyboardType: TextInputType.emailAddress, textDirection: TextDirection.ltr, autofillHints: const [AutofillHints.email]),
      ],
      const SizedBox(height: 18),
      Text(widget.onboarding ? t.wilayaQuestion : t.wilaya, style: label),
      const SizedBox(height: 8),
      wilayas.when(
        data: (list) {
          final open = list.where((w) => w.isActive).toList();
          final soon = list.where((w) => !w.isActive).toList();
          DropdownMenuItem<int?> header(String text, int value) =>
              DropdownMenuItem<int?>(enabled: false, value: value, child: Text(text, style: TextStyle(color: palette.accent, fontWeight: FontWeight.w800, fontSize: 13)));
          return DropdownButtonFormField<int?>(
            initialValue: list.any((w) => w.id == _wilayaId) ? _wilayaId : null,
            isExpanded: true,
            hint: Text(t.chooseWilaya),
            borderRadius: BorderRadius.circular(18),
            menuMaxHeight: 420,
            items: [
              header(t.wilayasOpen, -1),
              for (final w in open) DropdownMenuItem(value: w.id, child: Text(w.label)),
              header(t.wilayasSoon, -2),
              for (final w in soon) DropdownMenuItem(value: w.id, child: Text(w.label)),
            ],
            onChanged: (value) => setState(() => _wilayaId = value),
          );
        },
        loading: () => const LinearProgressIndicator(),
        error: (_, _) => RetryCard(onRetry: () => ref.invalidate(wilayasProvider)),
      ),
      const SizedBox(height: 22),
      Text(widget.onboarding ? t.interestsQuestion : t.interests, style: label),
      if (widget.onboarding) ...[
        const SizedBox(height: 4),
        Text(t.interestsHint, style: TextStyle(color: palette.muted, fontSize: 13.5)),
      ],
      const SizedBox(height: 12),
      categories.when(
        data: (list) => Wrap(spacing: 8, runSpacing: 10, children: [
          for (final category in list)
            ChoicePill(
              label: category.name,
              selected: _interests.contains(category.slug),
              leading: CategoryDot(icon: category.icon, color: category.color, size: 28),
              onTap: () => setState(() => _interests.contains(category.slug) ? _interests.remove(category.slug) : _interests.add(category.slug)),
            ),
        ]),
        loading: () => const LinearProgressIndicator(),
        error: (_, _) => RetryCard(onRetry: () => ref.invalidate(categoriesProvider)),
      ),
      if (_error != null) ...[
        const SizedBox(height: 16),
        Text(_error!, style: const TextStyle(color: DowraColors.error, fontWeight: FontWeight.w600)),
      ],
      const SizedBox(height: 26),
      GradientButton(label: widget.submitLabel, loading: _saving, onPressed: _submit),
    ]);
  }
}
