import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('Rejected edits preserve formatter state', () {
    test('Adding a rejected negative sign keeps the accepted positive value',
        () {
      final List<String> changes = <String>[];
      final CurrencyTextInputFormatter formatter =
          CurrencyTextInputFormatter.currency(
        symbol: r'$',
        minValue: 0,
        onChange: changes.add,
      );
      final TextEditingValue accepted = formatter.formatEditUpdate(
          TextEditingValue.empty, const TextEditingValue(text: '500'));
      final TextEditingValue rejected = formatter.formatEditUpdate(
          accepted, accepted.copyWith(text: r'-$5.00'));

      expect(rejected, accepted);
      expect(formatter.getFormattedValue(), r'$5.00');
      expect(formatter.getUnformattedValue(), 5);
      expect(changes, <String>[r'$5.00']);
    });

    test('Removing a rejected negative sign keeps the accepted negative value',
        () {
      final CurrencyTextInputFormatter formatter =
          CurrencyTextInputFormatter.currency(symbol: r'$', maxValue: 0);
      final TextEditingValue accepted = formatter.formatEditUpdate(
          TextEditingValue.empty, const TextEditingValue(text: '-500'));
      final TextEditingValue rejected = formatter.formatEditUpdate(
          accepted, accepted.copyWith(text: r'$5.00'));

      expect(rejected, accepted);
      expect(formatter.getFormattedValue(), r'-$5.00');
      expect(formatter.getUnformattedValue(), -5);
    });
  });

  test('Replacing selected text with zero is not treated as backspace', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(symbol: '');
    final TextEditingValue result = formatter.formatEditUpdate(
      const TextEditingValue(
          text: '10.00',
          selection: TextSelection(baseOffset: 0, extentOffset: 5)),
      const TextEditingValue(
          text: '0.00', selection: TextSelection.collapsed(offset: 4)),
    );

    expect(result.text, '0.00');
    expect(formatter.getUnformattedValue(), 0);
  });

  for (final int decimalDigits in <int>[0, 1, 2, 3]) {
    test('Zero input and deletion with $decimalDigits decimal digits', () {
      final CurrencyTextInputFormatter formatter =
          CurrencyTextInputFormatter.currency(
              symbol: r'$', decimalDigits: decimalDigits);
      final String zero = 0.toStringAsFixed(decimalDigits);
      final TextEditingValue value = formatter.formatEditUpdate(
          TextEditingValue.empty, TextEditingValue(text: zero));
      expect(value.text, '\$$zero');
      final TextEditingValue deleted = formatter.formatEditUpdate(value,
          value.copyWith(text: value.text.substring(0, value.text.length - 1)));
      expect(deleted.text, '');
      expect(formatter.getUnformattedValue(), 0);
    });
  }

  test('Cursor is preserved with negative values and a suffix symbol', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(
            locale: 'es', symbol: '€', maintainCursorPosition: true);
    final TextEditingValue result = formatter.formatEditUpdate(
      const TextEditingValue(
          text: '-123,45\u00a0€',
          selection: TextSelection.collapsed(offset: 3)),
      const TextEditingValue(
          text: '-13,45\u00a0€', selection: TextSelection.collapsed(offset: 2)),
    );
    expect(result.text, '-13,45\u00a0€');
    expect(result.selection.baseOffset, 2);
    expect(formatter.getUnformattedValue(), -13.45);
  });

  test('Cursor option is forwarded by every constructor', () {
    final List<CurrencyTextInputFormatter> formatters =
        <CurrencyTextInputFormatter>[
      CurrencyTextInputFormatter(NumberFormat.currency(symbol: ''),
          maintainCursorPosition: true),
      CurrencyTextInputFormatter.currency(
          symbol: '', maintainCursorPosition: true),
      CurrencyTextInputFormatter.simpleCurrency(
          locale: 'en_US', maintainCursorPosition: true),
    ];
    for (final CurrencyTextInputFormatter formatter in formatters) {
      final TextEditingValue result = formatter.formatEditUpdate(
        const TextEditingValue(text: '123.45'),
        const TextEditingValue(
            text: '13.45', selection: TextSelection.collapsed(offset: 1)),
      );
      expect(result.text.substring(result.selection.baseOffset), '3.45');
    }
  });

  test('Missing selection falls back to the end', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(maintainCursorPosition: true);
    final TextEditingValue result = formatter.formatEditUpdate(
        TextEditingValue.empty, const TextEditingValue(text: '12345'));
    expect(result.selection.baseOffset, result.text.length);
  });

  test('Cursor option does not change left input behavior', () {
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.currency(
      inputDirection: InputDirection.left,
      maintainCursorPosition: true,
    );
    const TextEditingValue newValue = TextEditingValue(
        text: '13.45', selection: TextSelection.collapsed(offset: 1));
    expect(
        formatter.formatEditUpdate(
            const TextEditingValue(text: '123.45'), newValue),
        newValue);
  });
}
