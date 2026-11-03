import 'package:dowra/core/phone.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accepte les mobiles algériens sous toutes leurs formes', () {
    expect(normalizePhone('0550123456'), '+213550123456');
    expect(normalizePhone('0661 23 45 67'), '+213661234567');
    expect(normalizePhone('+213 770-12-34-56'), '+213770123456');
    expect(normalizePhone('00213550123456'), '+213550123456');
  });

  test('refuse les fixes, les numéros courts et étrangers', () {
    expect(normalizePhone('021123456'), isNull);
    expect(normalizePhone('12345'), isNull);
    expect(normalizePhone('+33612345678'), isNull);
    expect(normalizePhone(''), isNull);
  });

  test('affiche le numéro au format local', () {
    expect(formatPhone('+213550000010'), '05 50 00 00 10');
  });
}
