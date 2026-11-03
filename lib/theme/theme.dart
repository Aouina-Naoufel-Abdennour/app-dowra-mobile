import 'package:flutter/material.dart';

import 'colors.dart';

/// Thème Material de Dowra, en clair et en sombre ; police arabe pour l'arabe.
ThemeData dowraTheme({required Brightness brightness, required String locale}) {
  final palette = brightness == Brightness.dark ? DowraPalette.dark : DowraPalette.light;
  final family = locale == 'ar' ? 'NotoKufiArabic' : 'PlusJakartaSans';
  final fallback = locale == 'ar' ? const ['PlusJakartaSans'] : const ['NotoKufiArabic'];
  final scheme = ColorScheme.fromSeed(
    seedColor: DowraColors.neon,
    brightness: brightness,
    primary: palette.accent,
    surface: palette.surface,
    error: DowraColors.error,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    fontFamily: family,
    fontFamilyFallback: fallback,
    scaffoldBackgroundColor: palette.background,
    extensions: [palette],
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: palette.text, displayColor: palette.text, fontFamily: family, fontFamilyFallback: fallback),
    appBarTheme: AppBarTheme(backgroundColor: palette.background, foregroundColor: palette.text, elevation: 0, scrolledUnderElevation: 0, centerTitle: false),
    dividerTheme: DividerThemeData(color: palette.line, space: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.surface,
      hintStyle: TextStyle(color: palette.muted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: palette.line)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: palette.line)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: DowraColors.neon, width: 2)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: DowraColors.mauve950,
      contentTextStyle: TextStyle(fontFamily: family, color: Colors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dialogTheme: DialogThemeData(backgroundColor: palette.surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: palette.surface, showDragHandle: true),
  );
}
