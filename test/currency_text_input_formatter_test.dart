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
    var value = formatter.formatEditUpdate(TextEditingValue(text: '1,234.56'),
        TextEditingValue(text: '1,234.567'));
    expect(value.text, '12,345.67');
  });

  group('Erasing last digit works', () {
    CurrencyTextInputFormatter formatter;
    String eraseLast(String text) => formatter
        .formatEditUpdate(
          TextEditingValue(text: text),
          TextEditingValue(text: removeLast(text)),
        )
        .text;

    test('With the default parameters', () {
      formatter = CurrencyTextInputFormatter();

      expect(eraseLast('12,345.67'), '1,234.56');
      expect(eraseLast('1,234.56'), '123.45');
      expect(eraseLast('123.45'), '12.34');
      expect(eraseLast('12.34'), '1.23');
      expect(eraseLast('1.23'), '0.12');
      expect(eraseLast('0.12'), '0.01');
      expect(eraseLast('0.01'), '');
    });

    test('With a suffix symbol', () {
      formatter = CurrencyTextInputFormatter(symbol: '€', locale: 'es');

      var nbsp = String.fromCharCode(0xa0);
      expect(eraseLast('12.345,67' + nbsp + '€'), '1.234,56' + nbsp + '€');
      expect(eraseLast('1.234,56' + nbsp + '€'), '123,45' + nbsp + '€');
      expect(eraseLast('123,45' + nbsp + '€'), '12,34' + nbsp + '€');
      expect(eraseLast('12,34' + nbsp + '€'), '1,23' + nbsp + '€');
      expect(eraseLast('1,23' + nbsp + '€'), '0,12' + nbsp + '€');
      expect(eraseLast('0,12' + nbsp + '€'), '0,01' + nbsp + '€');
      expect(eraseLast('0,01' + nbsp + '€'), '');
    });
  });

  group("Erasing last digit works despite Flutter's bug", () {
    // Apparently, Flutter has a bug where the framework calls
    // formatEditUpdate twice, or even four times, after a backspace press. It
    // might be related to https://github.com/flutter/flutter/issues/48608.
    // This only happens on some devices, when the keyboard type is set to
    // a keyboard with numbers. These tests simulate the bug and check that
    // the formatter works despite this problem. For discussion, see
    // https://github.com/gtgalone/currency_text_input_formatter/issues/11.

    CurrencyTextInputFormatter formatter;
    String formatEditUpdate(String oldText, String newText) => formatter
        .formatEditUpdate(
          TextEditingValue(text: oldText),
          TextEditingValue(text: newText),
        )
        .text;

    String eraseWithBugFormatterCalledTwice(String text) {
      String output1 = formatEditUpdate(text, removeLast(text));
      String output2 = formatEditUpdate(output1, removeLast(text));
      return output2;
    }

    String eraseWithBugFormatterCalledFourTimes(String text) {
      String output1 = formatEditUpdate(text, removeLast(text));
      String output2 = formatEditUpdate(output1, removeLast(text));
      String output3 = formatEditUpdate(output2, output1);
      String output4 = formatEditUpdate(output3, output2);
      return output4;
    }

    test('With the default parameters', () {
      formatter = CurrencyTextInputFormatter();

      expect(eraseWithBugFormatterCalledTwice('0.12'), '0.01');
      expect(eraseWithBugFormatterCalledTwice('123,456.78'), '12,345.67');
      expect(eraseWithBugFormatterCalledFourTimes('0.12'), '0.01');
      expect(eraseWithBugFormatterCalledFourTimes('123,456.78'), '12,345.67');
    });

    test('With a suffix symbol', () {
      formatter = CurrencyTextInputFormatter(symbol: '€', locale: 'es');

      var nbsp = String.fromCharCode(0xa0);
      expect(eraseWithBugFormatterCalledTwice('0,12' + nbsp + '€'),
          '0,01' + nbsp + '€');
      expect(eraseWithBugFormatterCalledTwice('123.456,78' + nbsp + '€'),
          '12.345,67' + nbsp + '€');
      expect(eraseWithBugFormatterCalledFourTimes('0,12' + nbsp + '€'),
          '0,01' + nbsp + '€');
      expect(eraseWithBugFormatterCalledFourTimes('123.456,78' + nbsp + '€'),
          '12.345,67' + nbsp + '€');
    });
  });
}

String removeLast(String s) => s.substring(0, s.length - 1);
