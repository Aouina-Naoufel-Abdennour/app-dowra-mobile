/// Barème des frais de paiement en ligne (en %), à la charge de l'acheteur.
class PaymentFees {
  const PaymentFees({this.cib = 0, this.edahabia = 0, this.minimum = 0});

  final double cib;
  final double edahabia;
  final int minimum;

  factory PaymentFees.fromJson(Object? json) {
    if (json is! Map) return const PaymentFees();
    return PaymentFees(
      cib: (json['cib'] as num?)?.toDouble() ?? 0,
      edahabia: (json['edahabia'] as num?)?.toDouble() ?? 0,
      minimum: (json['minimum'] as num?)?.toInt() ?? 0,
    );
  }

  /// Frais d'un paiement : même calcul que l'API (arrondi au dinar supérieur, avec un minimum).
  int forAmount(int amount, String method) {
    if (amount <= 0) return 0;
    final rate = method == 'edahabia' ? edahabia : cib;
    final fee = (amount * rate / 100).ceil();
    return fee < minimum ? minimum : fee;
  }
}
