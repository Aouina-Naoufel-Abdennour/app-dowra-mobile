import 'package:dowra/core/fees.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const fees = PaymentFees(cib: 1.5, edahabia: 2, minimum: 20);

  test('frais arrondis au dinar supérieur, avec le minimum', () {
    expect(fees.forAmount(5000, 'cib'), 75);
    expect(fees.forAmount(2030, 'cib'), 31);
    expect(fees.forAmount(500, 'cib'), 20);
    expect(fees.forAmount(5000, 'edahabia'), 100);
  });

  test('aucun frais quand rien n\'est à payer', () {
    expect(fees.forAmount(0, 'cib'), 0);
  });
}
