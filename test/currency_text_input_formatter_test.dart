import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Formats input without symbol by default', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(symbol: '');
    final TextEditingValue value = formatter.formatEditUpdate(
        TextEditingValue.empty, const TextEditingValue(text: '0'));
    expect(value.text, '0.00');
  });

  test('Formats input with correct number of digits', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(decimalDigits: 3);
    final TextEditingValue value = formatter.formatEditUpdate(
        TextEditingValue.empty, const TextEditingValue(text: '0'));
    expect(value.text, 'USD0.000');
  });

  test('Formats input correctly without decimal digits', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(symbol: '@', decimalDigits: 0);
    final TextEditingValue value = formatter.formatEditUpdate(
        TextEditingValue.empty, const TextEditingValue(text: '0'));
    expect(value.text, '@0');
  });

  test('Formats input correctly when decimal digits are null', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(symbol: '@');
    final TextEditingValue value = formatter.formatEditUpdate(
        TextEditingValue.empty, const TextEditingValue(text: '0'));
    expect(value.text, '@0.00');
  });

  test('Formats input with symbol, if symbol is provided', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(symbol: '@');
    final TextEditingValue value = formatter.formatEditUpdate(
        TextEditingValue.empty, const TextEditingValue(text: '0'));
    expect(value.text, '@0.00');
  });

  test('Formats input with locale, if locale is provided', () {
    // The 'es' locale differs in that it uses comma instead of a dot as separator.
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(locale: 'es');
    final TextEditingValue value = formatter.formatEditUpdate(
        TextEditingValue.empty, const TextEditingValue(text: '0'));
    final String nbsp = String.fromCharCode(0xa0);
    expect(value.text, '0,00${nbsp}EUR');
  });

  test('Formats input with symbol and locale, if both are provided', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(symbol: r'@$', locale: 'es');
    final TextEditingValue value = formatter.formatEditUpdate(
        TextEditingValue.empty, const TextEditingValue(text: '0'));
    final String nbsp = String.fromCharCode(0xa0);
    expect(value.text, '0,00' + nbsp + r'@$');
  });

  test(
      'Formats input with ISO code and locale, if locale is provided and symbol is null',
      () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(locale: 'es');
    final TextEditingValue value = formatter.formatEditUpdate(
        TextEditingValue.empty, const TextEditingValue(text: '0'));
    final String nbsp = String.fromCharCode(0xa0);
    expect(value.text, '0,00' + nbsp + 'EUR');
  });

  test('Formats longer string correctly', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency();
    final TextEditingValue value = formatter.formatEditUpdate(
      const TextEditingValue(text: '1,234.56'),
      const TextEditingValue(text: '1,234.567'),
    );
    expect(value.text, 'USD12,345.67');
  });

  test('Formats input correctly with negative numbers disabled', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(enableNegative: false);
    final TextEditingValue value = formatter.formatEditUpdate(
        TextEditingValue.empty, const TextEditingValue(text: '-100'));
    expect(value.text, 'USD1.00');
  });

  test('Format a double input and gets it back', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(
      enableNegative: false,
    );
    formatter.formatDouble(123.25);
    expect(formatter.getDouble(), 123.25);
  });

  test('Allows empty field when input direction is left', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(
      inputDirection: InputDirection.left,
    );
    // Simulate an existing non-empty value
    const TextEditingValue oldValue = TextEditingValue(text: '1');
    // New value is an empty string
    const TextEditingValue newValue = TextEditingValue(text: '');
    final TextEditingValue value =
        formatter.formatEditUpdate(oldValue, newValue);
    expect(value.text, '', reason: 'Empty input should remain empty');
  });

  test('Empty input remains empty with left input direction', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(
      inputDirection: InputDirection.left,
    );
    final TextEditingValue value = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(text: ''),
    );
    expect(value.text, '', reason: 'Empty input should remain empty');
  });

  test('Does not allow dot as first character when input direction is left',
      () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(
      inputDirection: InputDirection.left,
    );
    const TextEditingValue oldValue = TextEditingValue.empty;
    final TextEditingValue result = formatter.formatEditUpdate(
      oldValue,
      const TextEditingValue(text: '.'),
    );
    expect(result.text, '',
        reason: 'Dot should not be allowed as first character');
  });

  test('Does not allow space character in input', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency();

    const TextEditingValue oldValue = TextEditingValue(text: '0');
    const TextEditingValue newValue = TextEditingValue(text: '0 ');
    final TextEditingValue result =
        formatter.formatEditUpdate(oldValue, newValue);

    // Since spaces are not allowed, the formatter should return the old value.
    expect(result.text, oldValue.text,
        reason: 'Space characters should be restricted.');
  });

  test('Does not allow comma as first character when input direction is left',
      () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(
      inputDirection: InputDirection.left,
    );
    const TextEditingValue oldValue = TextEditingValue.empty;
    final TextEditingValue result = formatter.formatEditUpdate(
      oldValue,
      const TextEditingValue(text: ','),
    );
    expect(result.text, '',
        reason: 'Comma should not be allowed as first character');
  });

  group('Erasing last digit works', () {
    CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency();
    String eraseLast(String text) => formatter
        .formatEditUpdate(
          TextEditingValue(text: text),
          TextEditingValue(text: removeLast(text)),
        )
        .text;

    test('With the default parameters', () {
      formatter = CurrencyTextInputFormatter.currency();

      expect(eraseLast('12,345.67'), 'USD1,234.56');
      expect(eraseLast('1,234.56'), 'USD123.45');
      expect(eraseLast('123.45'), 'USD12.34');
      expect(eraseLast('12.34'), 'USD1.23');
      expect(eraseLast('1.23'), 'USD0.12');
      expect(eraseLast('0.12'), 'USD0.01');
      expect(eraseLast('0.01'), '');
    });

    test('With a suffix symbol', () {
      formatter =
          CurrencyTextInputFormatter.currency(symbol: '€', locale: 'es');

      final String nbsp = String.fromCharCode(0xa0);
      expect(eraseLast('12.345,67' + nbsp + '€'), '1.234,56' + nbsp + '€');
      expect(eraseLast('1.234,56' + nbsp + '€'), '123,45' + nbsp + '€');
      expect(eraseLast('123,45' + nbsp + '€'), '12,34' + nbsp + '€');
      expect(eraseLast('12,34' + nbsp + '€'), '1,23' + nbsp + '€');
      expect(eraseLast('1,23' + nbsp + '€'), '0,12' + nbsp + '€');
      expect(eraseLast('0,12' + nbsp + '€'), '0,01' + nbsp + '€');
      expect(eraseLast('0,01' + nbsp + '€'), '');
    });
  });

  // group("Erasing last digit works despite Flutter's bug", () {
  //   // Apparently, Flutter has a bug where the framework calls
  //   // formatEditUpdate twice, or even four times, after a backspace press. It
  //   // might be related to https://github.com/flutter/flutter/issues/48608.
  //   // This only happens on some devices, when the keyboard type is set to
  //   // a keyboard with numbers. These tests simulate the bug and check that
  //   // the formatter works despite this problem. For discussion, see
  //   // https://github.com/gtgalone/currency_text_input_formatter/issues/11.

  //   CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter.currency();
  //   String formatEditUpdate(String oldText, String newText) => formatter
  //       .formatEditUpdate(
  //         TextEditingValue(text: oldText),
  //         TextEditingValue(text: newText),
  //       )
  //       .text;

  //   String eraseWithBugFormatterCalledTwice(String text) {
  //     final String output1 = formatEditUpdate(text, removeLast(text));
  //     final String output2 = formatEditUpdate(output1, removeLast(text));
  //     return output2;
  //   }

  //   String eraseWithBugFormatterCalledFourTimes(String text) {
  //     final String output1 = formatEditUpdate(text, removeLast(text));
  //     final String output2 = formatEditUpdate(output1, removeLast(text));
  //     final String output3 = formatEditUpdate(output2, output1);
  //     final String output4 = formatEditUpdate(output3, output2);
  //     return output4;
  //   }

  //   test('With the default parameters', () {
  //     formatter = CurrencyTextInputFormatter.currency();

  //     expect(eraseWithBugFormatterCalledTwice('0.12'), 'USD0.01');
  //     expect(eraseWithBugFormatterCalledTwice('123,456.78'), 'USD12,345.67');
  //     expect(eraseWithBugFormatterCalledFourTimes('0.12'), 'USD0.01');
  //     expect(
  //         eraseWithBugFormatterCalledFourTimes('123,456.78'), 'USD12,345.67');
  //   });

  //   test('With a suffix symbol', () {
  //     formatter = CurrencyTextInputFormatter.currency(symbol: '€', locale: 'es');

  //     final String nbsp = String.fromCharCode(0xa0);
  //     expect(eraseWithBugFormatterCalledTwice('0,12' + nbsp + '€'),
  //         '0,01' + nbsp + '€');
  //     expect(eraseWithBugFormatterCalledTwice('123.456,78' + nbsp + '€'),
  //         '12.345,67' + nbsp + '€');
  //     expect(eraseWithBugFormatterCalledFourTimes('0,12' + nbsp + '€'),
  //         '0,01' + nbsp + '€');
  //     expect(eraseWithBugFormatterCalledFourTimes('123.456,78' + nbsp + '€'),
  //         '12.345,67' + nbsp + '€');
  //   });
  // });
}

String removeLast(String s) => s.substring(0, s.length - 1);
