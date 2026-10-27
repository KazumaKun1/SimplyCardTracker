import 'package:flutter_test/flutter_test.dart';
import 'package:simplycardtracker/core/domain/currency.dart';
import 'package:simplycardtracker/core/extensions/formatting/currency_formatting.dart';

void main() {
  group('Currency Format', () {
    test('PHP with grouping and two decimals', () {
      expect(Currency.php.format(12000070), '₱120,000.70');
    });

    test('USD', () {
      expect(Currency.usd.format(125000), r'$1,250.00');
    });

    test('zero', () {
      expect(Currency.php.format(0), '₱0.00');
    });
  });
}
