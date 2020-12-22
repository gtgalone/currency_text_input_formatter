import 'package:flutter_test/flutter_test.dart';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

void main() {
  test('Formats input without symbol by default', () {
    var formatter = CurrencyTextInputFormatter();
    var value = formatter.formatEditUpdate(
        TextEditingValue.empty, TextEditingValue(text: '0'));
    expect(value.text, '0.00');
  });

  test('Formats input with correct number of digits', () {
    var formatter = CurrencyTextInputFormatter(decimalDigits: 3);
    var value = formatter.formatEditUpdate(
        TextEditingValue.empty, TextEditingValue(text: '0'));
    expect(value.text, '0.000');
  });

  test('Formats input correctly without decimal digits', () {
    var formatter = CurrencyTextInputFormatter(symbol: '@', decimalDigits: 0);
    var value = formatter.formatEditUpdate(
        TextEditingValue.empty, TextEditingValue(text: '0'));
    expect(value.text, '@0');
  });

  test('Formats input with symbol, if symbol is provided', () {
    var formatter = CurrencyTextInputFormatter(symbol: '@');
    var value = formatter.formatEditUpdate(
        TextEditingValue.empty, TextEditingValue(text: '0'));
    expect(value.text, '@0.00');
  });

  test('Formats input with locale, if locale is provided', () {
    // The 'es' locale differs in that it uses comma instead of a dot as separator.
    var formatter = CurrencyTextInputFormatter(locale: 'es');
    var value = formatter.formatEditUpdate(
        TextEditingValue.empty, TextEditingValue(text: '0'));
    expect(value.text, '0,00');
  });

  test('Formats input with symbol and locale, if both are provided', () {
    var formatter = CurrencyTextInputFormatter(symbol: r'@$', locale: 'es');
    var value = formatter.formatEditUpdate(
        TextEditingValue.empty, TextEditingValue(text: '0'));
    var nbsp = String.fromCharCode(0xa0);
    expect(value.text, '0,00' + nbsp + r'@$');
  });

  test(
      'Formats input with ISO code and locale, if locale is provided and symbol is null',
      () {
    var formatter = CurrencyTextInputFormatter(symbol: null, locale: 'es');
    var value = formatter.formatEditUpdate(
        TextEditingValue.empty, TextEditingValue(text: '0'));
    var nbsp = String.fromCharCode(0xa0);
    expect(value.text, '0,00' + nbsp + 'EUR');
  });

  test('Formats longer string correctly', () {
    var formatter = CurrencyTextInputFormatter();
    var value = formatter.formatEditUpdate(
        TextEditingValue.empty, TextEditingValue(text: '10050'));
    expect(value.text, '100.50');
  });
}
