import 'package:flutter/foundation.dart';

/// Comptes de test du backend (DemoUserSeeder), proposés seulement dans une version de développement.
class DemoAccount {
  const DemoAccount(this.phone, this.labels);

  final String phone;
  final Map<String, String> labels;

  String label(String locale) => labels[locale] ?? labels['fr']!;
}

const demoAccounts = [
  DemoAccount('05 50 00 00 10', {'fr': 'Utilisateur', 'ar': 'مستخدم', 'en': 'User'}),
  DemoAccount('05 50 00 00 11', {'fr': 'Ambassadeur', 'ar': 'سفير', 'en': 'Ambassador'}),
  DemoAccount('05 50 00 00 20', {'fr': 'Organisateur vérifié', 'ar': 'منظم موثق', 'en': 'Verified organiser'}),
  DemoAccount('05 50 00 00 21', {'fr': 'Organisateur Pro', 'ar': 'منظم محترف', 'en': 'Pro organiser'}),
  DemoAccount('05 50 00 00 22', {'fr': 'Organisateur non vérifié', 'ar': 'منظم غير موثق', 'en': 'Unverified organiser'}),
  DemoAccount('05 50 00 00 23', {'fr': 'Équipe d\'accueil', 'ar': 'فريق الاستقبال', 'en': 'Check-in staff'}),
];

const demoCode = '123456';

/// Pré-remplissage actif en mode debug, ou forcé en recette avec --dart-define=DOWRA_DEMO_ACCOUNTS=true.
bool get demoAccountsEnabled => kDebugMode || const bool.fromEnvironment('DOWRA_DEMO_ACCOUNTS');
