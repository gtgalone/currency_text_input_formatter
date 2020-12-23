library currency_text_input_formatter;

import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// The `symbol` argument is used to symbol of NumberFormat.
/// Put '\$' for symbol
///
/// The `locale` argument is used to locale of NumberFormat.
/// Put 'en' or 'es' for locale
///
/// The `decimalDigits` argument is used to decimalDigits of NumberFormat.
/// Defaults `decimalDigits` is 2.
class CurrencyTextInputFormatter extends TextInputFormatter {
  CurrencyTextInputFormatter({
    this.symbol = '',
    this.locale,
    this.decimalDigits = 2,
  });

  final String symbol;
  final String locale;
  final int decimalDigits;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    bool isInsertedCharacter =
        oldValue.text.length + 1 == newValue.text.length &&
            newValue.text.startsWith(oldValue.text);
    bool isRemovedCharacter =
        oldValue.text.length - 1 == newValue.text.length &&
            oldValue.text.startsWith(newValue.text);

    // Apparently, Flutter has a bug where the framework calls
    // formatEditUpdate twice, or even four times, after a backspace press (see
    // https://github.com/gtgalone/currency_text_input_formatter/issues/11).
    // However, only the first of these calls has inputs which are consistent
    // with a character insertion/removal at the end (which is the most common
    // use case of editing the TextField - the others being insertion/removal
    // in the middle, or pasting text onto the TextField). This condition
    // fixes a problem where a character wasn't properly erased after a
    // backspace press, when this Flutter bug was present. This comes at the
    // cost of losing insertion/removal in the middle and pasting text.
    if (!isInsertedCharacter && !isRemovedCharacter) {
      return oldValue;
    }

    final format = NumberFormat.currency(
        locale: locale, decimalDigits: decimalDigits, symbol: symbol);
    bool isNegative = newValue.text.startsWith('-');
    String newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    // If the user wants to remove a digit, but the last character of the
    // formatted text is not a digit (for example, "1,00 €"), we need to remove
    // the digit manually.
    if (isRemovedCharacter && !_lastCharacterIsDigit(oldValue.text)) {
      newText = newText.substring(0, newText.length - 1);
    }

    if (newText.trim() == '') {
      return newValue.copyWith(
          text: isNegative ? '-' : '',
          selection: TextSelection.collapsed(offset: isNegative ? 1 : 0));
    } else if (newText == '00' || newText == '000') {
      return TextEditingValue(
          text: isNegative ? '-' : '',
          selection: TextSelection.collapsed(offset: isNegative ? 1 : 0));
    }

    dynamic newInt = int.parse(newText);
    if (decimalDigits > 0) {
      newInt /= pow(10, decimalDigits);
    }
    String newString = (isNegative ? '-' : '') + format.format(newInt).trim();
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }

  static bool _lastCharacterIsDigit(String text) {
    String lastChar = text.substring(text.length - 1);
    return RegExp('[0-9]').hasMatch(lastChar);
  }
}
