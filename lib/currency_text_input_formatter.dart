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
    final format = NumberFormat.currency(
        locale: locale, decimalDigits: decimalDigits, symbol: symbol);
    String newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    if (newText.trim() == '') {
      return newValue.copyWith(text: '');
    } else if ((oldValue.text == '${symbol}0.00') &&
        (int.parse(newText) == 0)) {
      return newValue.copyWith(text: '');
    }

    dynamic newInt = int.parse(newText);
    var selectionIndexFromTheRight =
        newValue.text.length - newValue.selection.end;
    if (decimalDigits > 0) {
      newInt /= pow(10, decimalDigits);
    }
    String newString = format.format(newInt);
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight),
    );
  }
}
