library currency_text_input_formatter;

import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// The `symbol` argument is used to symbol of NumberFormat currency.
/// Defaults `symbol` is null.
/// Put '\$' for symbol
///
/// The `locale` argument is used to locale of NumberFormat currency.
/// Defaults `locale` is null.
/// Put 'en' or 'es' for locale
///
/// The `name` argument is used to locale of NumberFormat currency.
/// Defaults `name` is null.
/// the currency with that ISO 4217 name will be used.
/// Otherwise we will use the default currency name for the current locale.
/// If no [symbol] is specified, we will use the currency name in the formatted result.
/// e.g. var f = NumberFormat.currency(locale: 'en_US', name: 'EUR') will format currency like "EUR1.23".
/// If we did not specify the name, it would format like "USD1.23".
///
/// The `decimalDigits` argument is used to decimalDigits of NumberFormat currency.
/// Defaults `decimalDigits` is null.
///
/// The `customPattern` argument is used to locale of NumberFormat currency.
/// Defaults `name` is null.
/// Can be used to specify a particular format.
/// This is useful if you have your own locale data which includes unsupported formats
/// (e.g. accounting format for currencies.)
///
/// The `turnOffGrouping` argument is used to locale of NumberFormat currency.
/// Defaults `turnOffGrouping` is false.
/// Explicitly turn off any grouping (e.g. by thousands) in this format.
/// This is used in compact number formatting, where we omit the normal grouping.
/// Best to know what you're doing if you call it.
///
class CurrencyTextInputFormatter extends TextInputFormatter {
  CurrencyTextInputFormatter({
    this.locale,
    this.name,
    this.symbol,
    this.decimalDigits,
    this.customPattern,
    this.turnOffGrouping = false,
  });

  final String? locale;
  final String? name;
  final String? symbol;
  final int? decimalDigits;
  final String? customPattern;
  final bool turnOffGrouping;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final bool isInsertedCharacter =
        oldValue.text.length + 1 == newValue.text.length &&
            newValue.text.startsWith(oldValue.text);
    final bool isRemovedCharacter =
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

    final NumberFormat format = NumberFormat.currency(
      locale: locale,
      name: name,
      symbol: symbol,
      decimalDigits: decimalDigits,
      customPattern: customPattern,
    );
    if (turnOffGrouping) {
      format.turnOffGrouping();
    }
    final bool isNegative = newValue.text.startsWith('-');
    String newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    // If the user wants to remove a digit, but the last character of the
    // formatted text is not a digit (for example, "1,00 €"), we need to remove
    // the digit manually.
    if (isRemovedCharacter && !_lastCharacterIsDigit(oldValue.text)) {
      final int length = newText.length - 1;
      newText = newText.substring(0, length > 0 ? length : 0);
    }

    if (newText.trim() == '') {
      return newValue.copyWith(
        text: isNegative ? '-' : '',
        selection: TextSelection.collapsed(offset: isNegative ? 1 : 0),
      );
    } else if (newText == '00' || newText == '000') {
      return TextEditingValue(
        text: isNegative ? '-' : '',
        selection: TextSelection.collapsed(offset: isNegative ? 1 : 0),
      );
    }

    num newInt = int.parse(newText);
    if (format.decimalDigits! > 0) {
      newInt /= pow(10, format.decimalDigits!);
    }
    final String newString =
        (isNegative ? '-' : '') + format.format(newInt).trim();
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }

  static bool _lastCharacterIsDigit(String text) {
    final String lastChar = text.substring(text.length - 1);
    return RegExp('[0-9]').hasMatch(lastChar);
  }
}
