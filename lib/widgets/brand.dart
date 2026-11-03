import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/colors.dart';

/// Humeurs de Dowri, le « d » du logo qui prend vie.
enum DowriMood { salut, content, fete, billet, route, carte, repos, triste }

class Dowri extends StatelessWidget {
  const Dowri(this.mood, {super.key, this.size = 140});

  final DowriMood mood;
  final double size;

  @override
  Widget build(BuildContext context) =>
      SvgPicture.asset('assets/dowri/dowri-${mood.name}.svg', width: size, height: size, excludeFromSemantics: true);
}

const _logoMark = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#6D28D9"/><stop offset=".5" stop-color="#A93BF5"/><stop offset="1" stop-color="#E14BD8"/></linearGradient></defs><rect width="100" height="100" rx="26" fill="url(#g)"/><g transform="translate(9 4) scale(.88)"><path d="M70 12V86" stroke="#fff" stroke-width="13" stroke-linecap="round" fill="none"/><path d="M70 62A25 25 0 1 0 45 87" stroke="#fff" stroke-width="13" stroke-linecap="round" fill="none"/><circle cx="45" cy="62" r="7" fill="#FFD21F"/></g></svg>''';

/// Logo « la boucle » ; le mot « dowra » reste en latin dans toutes les langues.
class DowraLogo extends StatelessWidget {
  const DowraLogo({super.key, this.size = 36, this.color, this.showWord = true});

  final double size;
  final Color? color;
  final bool showWord;

  @override
  Widget build(BuildContext context) {
    final mark = SvgPicture.string(_logoMark, width: size, height: size, excludeFromSemantics: true);
    if (!showWord) return mark;
    return Semantics(
      label: 'Dowra',
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          mark,
          SizedBox(width: size * 0.26),
          Text('dowra',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: size * 0.68,
                fontWeight: FontWeight.w800,
                letterSpacing: -size * 0.03,
                color: color ?? context.palette.text,
              )),
        ]),
      ),
    );
  }
}

/// Texte en dégradé de marque (mot mis en avant dans les titres).
class GradientText extends StatelessWidget {
  const GradientText(this.text, {super.key, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => (dark
              ? const LinearGradient(colors: [Color(0xFFC595FF), Color(0xFFD98BFF), Color(0xFFF08AE8)])
              : DowraColors.gradient)
          .createShader(Offset.zero & bounds.size),
      child: Text(text, style: style),
    );
  }
}

/// Titre de la charte : « Mes » + mot en dégradé italique (« billets »).
class BrandTitle extends StatelessWidget {
  const BrandTitle(this.start, this.emphasis, {super.key, this.size = 30, this.color});

  final String start;
  final String emphasis;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final arabic = Directionality.of(context) == TextDirection.rtl;
    final style = TextStyle(fontSize: size, fontWeight: FontWeight.w800, height: arabic ? 1.4 : 1.1, letterSpacing: arabic ? 0 : -size * 0.03, color: color ?? context.palette.text);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        if (start.trim().isNotEmpty) Text('$start ', style: style),
        GradientText(emphasis, style: style.copyWith(fontStyle: arabic ? FontStyle.normal : FontStyle.italic)),
      ],
    );
  }
}

/// Étiquette manuscrite (Caveat) au-dessus d'un titre.
class HandTag extends StatelessWidget {
  const HandTag(this.text, {super.key, this.background, this.foreground});

  final String text;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final arabic = Directionality.of(context) == TextDirection.rtl;
    return Transform.rotate(
      angle: -0.04,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 5, 12, 4),
        decoration: BoxDecoration(color: background ?? context.palette.pale, borderRadius: BorderRadius.circular(10)),
        child: Text(text,
            style: TextStyle(
              fontFamily: arabic ? 'NotoKufiArabic' : 'Caveat',
              fontSize: arabic ? 14 : 22,
              fontWeight: FontWeight.w700,
              height: 1.1,
              color: foreground ?? context.palette.accent,
            )),
      ),
    );
  }
}

/// Pictogramme associé à une icône de l'API (catégorie, type de sortie).
IconData iconFor(String? name) => switch (name) {
      'sun' => Icons.wb_sunny_outlined,
      'mountain' => Icons.terrain_outlined,
      'waves' => Icons.waves_outlined,
      'music' => Icons.music_note_outlined,
      'masks' => Icons.theater_comedy_outlined,
      'landmark' => Icons.account_balance_outlined,
      'utensils' => Icons.restaurant_outlined,
      'trophy' => Icons.emoji_events_outlined,
      'users' => Icons.groups_outlined,
      'heart' => Icons.favorite_border,
      'bus' => Icons.directions_bus_outlined,
      'film' => Icons.movie_outlined,
      'ticket' => Icons.confirmation_number_outlined,
      'palette' => Icons.palette_outlined,
      'gift' => Icons.redeem_outlined,
      _ => Icons.auto_awesome_outlined,
    };
