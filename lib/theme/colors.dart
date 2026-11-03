import 'package:flutter/material.dart';

/// Charte Dowra : dégradé mauve pour l'action forte, jaune soleil en petit signal, neutres teintés mauve.
abstract final class DowraColors {
  static const violet = Color(0xFF6D28D9);
  static const neon = Color(0xFFA93BF5);
  static const rose = Color(0xFFE14BD8);
  static const mauve50 = Color(0xFFF7F0FF);
  static const mauve100 = Color(0xFFEDDEFF);
  static const mauve200 = Color(0xFFDCBCFF);
  static const mauve300 = Color(0xFFC595FF);
  static const mauve600 = Color(0xFF7E2FD8);
  static const mauve900 = Color(0xFF2E0F55);
  static const mauve950 = Color(0xFF1A0833);
  static const sun = Color(0xFFFFD21F);
  static const ink = Color(0xFF120C1C);
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFE5484D);

  static const gradient = LinearGradient(
    begin: Alignment(-1, -0.6),
    end: Alignment(1, 0.6),
    colors: [violet, neon, rose],
  );

  /// Couleur d'une catégorie de l'API (« #A93BF5 »), mauve si absente.
  static Color fromHex(String? hex) {
    final value = int.tryParse((hex ?? '').replaceFirst('#', ''), radix: 16);
    return value == null ? neon : Color(0xFF000000 | value);
  }
}

/// Couleurs de surface et de texte, différentes en clair et en sombre.
@immutable
class DowraPalette extends ThemeExtension<DowraPalette> {
  const DowraPalette({
    required this.background,
    required this.surface,
    required this.soft,
    required this.pale,
    required this.line,
    required this.text,
    required this.muted,
    required this.accent,
  });

  final Color background;
  final Color surface;
  final Color soft;
  final Color pale;
  final Color line;
  final Color text;
  final Color muted;
  final Color accent;

  static const light = DowraPalette(
    background: Color(0xFFF7F5FA),
    surface: Colors.white,
    soft: Color(0xFFEFEAF5),
    pale: Color(0xFFF3ECFB),
    line: Color(0xFFE3DCEB),
    text: DowraColors.ink,
    muted: Color(0xFF5A5266),
    accent: DowraColors.mauve600,
  );

  static const dark = DowraPalette(
    background: Color(0xFF0E0A14),
    surface: Color(0xFF18121F),
    soft: Color(0xFF241B2E),
    pale: Color(0xFF241B2E),
    line: Color(0xFF2E2539),
    text: Colors.white,
    muted: Color(0xFFB7AEC4),
    accent: DowraColors.mauve300,
  );

  @override
  DowraPalette copyWith() => this;

  @override
  DowraPalette lerp(ThemeExtension<DowraPalette>? other, double t) {
    if (other is! DowraPalette) return this;
    return DowraPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      soft: Color.lerp(soft, other.soft, t)!,
      pale: Color.lerp(pale, other.pale, t)!,
      line: Color.lerp(line, other.line, t)!,
      text: Color.lerp(text, other.text, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}

extension DowraPaletteContext on BuildContext {
  DowraPalette get palette => Theme.of(this).extension<DowraPalette>()!;
}
