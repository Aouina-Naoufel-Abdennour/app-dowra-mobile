import 'package:intl/intl.dart';

/// Heure d'Alger (UTC+1, sans heure d'été) quel que soit le fuseau du téléphone.
DateTime algiers(DateTime date) => date.toUtc().add(const Duration(hours: 1));

String _locale(String lang) => lang == 'ar' ? 'ar_DZ' : lang;

/// « 24 000 DA » (« 24 000 دج » en arabe).
String formatPrice(String lang, int amount) {
  final number = NumberFormat.decimalPattern('fr_FR').format(amount).replaceAll(RegExp(r'[  ]'), ' ');
  return lang == 'ar' ? '$number دج' : '$number DA';
}

/// « ven. 6 nov. · 20:00 »
String formatDateTime(String lang, DateTime date) {
  final local = algiers(date);
  final day = DateFormat('EEE d MMM', _locale(lang)).format(local);
  return '$day · ${DateFormat('HH:mm').format(local)}';
}

/// « vendredi 6 novembre »
String formatLongDay(String lang, DateTime date) => DateFormat('EEEE d MMMM', _locale(lang)).format(algiers(date));

String formatTime(DateTime date) => DateFormat('HH:mm').format(algiers(date));
