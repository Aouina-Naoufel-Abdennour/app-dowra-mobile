import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../widgets/brand.dart';

/// Écran de lancement pendant la reprise de session.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: DowraColors.gradient),
          child: Center(child: Dowri(DowriMood.salut, size: 160)),
        ),
      );
}
