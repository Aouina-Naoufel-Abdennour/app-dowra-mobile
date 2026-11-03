import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/catalogue_providers.dart';
import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';

/// Bouton « 📍 Alger ▾ » : ouvre la liste des wilayas (ouvertes d'abord).
class WilayaPickerButton extends ConsumerWidget {
  const WilayaPickerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final code = ref.watch(preferredWilayaProvider);
    final wilayas = ref.watch(wilayasProvider).value ?? const [];
    final name = wilayas.where((w) => w.code == code).map((w) => w.name).firstOrNull ?? t.allAlgeria;
    final palette = context.palette;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => _open(context, ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.place_outlined, size: 16, color: palette.accent),
          const SizedBox(width: 4),
          Text(name, style: TextStyle(color: palette.muted, fontSize: 13, fontWeight: FontWeight.w700)),
          Icon(Icons.expand_more_rounded, size: 18, color: palette.muted),
        ]),
      ),
    );
  }

  void _open(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final wilayas = ref.read(wilayasProvider).value ?? const [];
    final current = ref.read(preferredWilayaProvider);
    final ordered = [...wilayas.where((w) => w.isActive), ...wilayas.where((w) => !w.isActive)];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheet) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (_, controller) => ListView(controller: controller, children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 8), child: Text(t.chooseWilayaTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
          _tile(sheet, ref, null, t.allAlgeria, current == null),
          for (final w in ordered)
            _tile(sheet, ref, w.code, w.label, current == w.code, trailing: w.isActive ? null : Text(t.wilayasSoon, style: TextStyle(color: sheet.palette.muted, fontSize: 12))),
        ]),
      ),
    );
  }

  Widget _tile(BuildContext sheet, WidgetRef ref, int? code, String label, bool selected, {Widget? trailing}) => ListTile(
        title: Text(label, style: TextStyle(fontWeight: selected ? FontWeight.w800 : FontWeight.w500)),
        leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? DowraColors.mauve600 : sheet.palette.muted),
        trailing: trailing,
        onTap: () {
          ref.read(preferredWilayaProvider.notifier).set(code);
          final filters = ref.read(exploreFiltersProvider);
          ref.read(exploreFiltersProvider.notifier).set(filters.copyWith(wilaya: code));
          Navigator.of(sheet).pop();
        },
      );
}
