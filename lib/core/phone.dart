/// Numéros mobiles algériens : 05, 06 ou 07 suivis de 8 chiffres (même règle que le backend).
String? normalizePhone(String? input) {
  if (input == null) return null;
  var digits = input.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('00')) digits = digits.substring(2);
  if (digits.startsWith('213')) {
    digits = digits.substring(3);
  } else if (digits.startsWith('0')) {
    digits = digits.substring(1);
  }
  return RegExp(r'^[567]\d{8}$').hasMatch(digits) ? '+213$digits' : null;
}

/// +213550123456 → 05 50 12 34 56
String formatPhone(String phone) {
  if (!phone.startsWith('+213')) return phone;
  final match = RegExp(r'^(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$').firstMatch('0${phone.substring(4)}');
  return match == null ? phone : [for (var i = 1; i <= 5; i++) match.group(i)].join(' ');
}
