library currency_text_inputnumberFormatter;

import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Flutter plugin for currency text input formatter.
///
/// See [the official documentation](https://github.com/gtgalone/currency_text_inputnumberFormatter)
/// for more information on how to use TextInputFormatter.
class CurrencyTextInputFormatter extends TextInputFormatter {
  /// Builds an CurrencyTextInputFormatter with the following parameters.
  ///
  /// [numberFormat] NumberFormat of currency.
  ///
  /// [turnOffGrouping] argument is used to locale of NumberFormat currency.
  ///
  /// [enableNegative] argument is used to enable negative value.
  ///
  /// [inputDirection] argument is used to set input direction.
  ///
  /// [minValue] argument is used to set min value.
  ///
  /// [maxValue] argument is used to set max value.
  ///
  /// [onChange] argument is used to set callback when value is changed.
  CurrencyTextInputFormatter(
    this.numberFormat, {
    this.turnOffGrouping = false,
    this.enableNegative = true,
    this.inputDirection = InputDirection.right,
    this.minValue,
    this.maxValue,
    this.onChange,
  }) {
    if (turnOffGrouping) {
      numberFormat.turnOffGrouping();
    }
  }

  final NumberFormat numberFormat;

  /// Defaults `turnOffGrouping` is false.
  ///
  /// Explicitly turn off any grouping (e.g. by thousands) in this format.
  /// This is used in compact number formatting, where we omit the normal grouping.
  /// Best to know what you're doing if you call it.
  final bool turnOffGrouping;

  /// Defaults `enableNegative` is true.
  ///
  /// Set to false if you want to disable negative numbers.
  final bool enableNegative;

  /// Defaults `inputDirection` is InputDirection.right.
  ///
  /// Set to InputDirection.left if you want to type from left.
  /// InputDirection.left cannot support formatting for now. You need to format
  /// your self.
  final InputDirection inputDirection;

  /// Defaults `minValue` is null.
  final num? minValue;

  /// Defaults `maxValue` is null.
  final num? maxValue;

  /// Callback when value is changed.
  /// You can use this to listen to value changes.
  /// e.g. onChange: (value) => print(value);
  final Function(String)? onChange;

  num _newNum = 0;
  String _newString = '';
  bool _isNegative = false;

  void numberFormatter(String newText) {
    _newNum = num.tryParse(newText) ?? 0;
    if (numberFormat.decimalDigits! > 0) {
      _newNum /= pow(10, numberFormat.decimalDigits!);
    }
    _newString = (_isNegative ? '-' : '') + numberFormat.format(_newNum).trim();
  }

  bool _isLessThanMinValue() {
    if (minValue == null) {
      return false;
    }
    return _newNum < minValue!;
  }

  bool _isMoreThanMaxValue() {
    if (maxValue == null) {
      return false;
    }
    return _newNum > maxValue!;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final bool isLeft = inputDirection == InputDirection.left;
    if (isLeft) {
      final List<String> nums = newValue.text.split('.');
      if (nums.length > 2) {
        return oldValue;
      }
      if (nums.length == 2 &&
          (nums[1].length > (numberFormat.decimalDigits ?? 2))) {
        return oldValue;
      }
      final double? v = double.tryParse(newValue.text);
      if (v == null) {
        return oldValue;
      }
      _newNum = v;
      _newString = newValue.text;
      if (_isLessThanMinValue() || _isMoreThanMaxValue()) {
        return oldValue;
      }
      return newValue;
    }

    // final bool isInsertedCharacter =
    //     oldValue.text.length + 1 == newValue.text.length &&
    //         newValue.text.startsWith(oldValue.text);
    final bool isRemovedCharacter =
        oldValue.text.length - 1 == newValue.text.length &&
            oldValue.text.startsWith(newValue.text);

    // Apparently, Flutter has a bug where the framework calls
    // formatEditUpdate twice, or even four times, after a backspace press (see
    // https://github.com/gtgalone/currency_text_inputnumberFormatter/issues/11).
    // However, only the first of these calls has inputs which are consistent
    // with a character insertion/removal at the end (which is the most common
    // use case of editing the TextField - the others being insertion/removal
    // in the middle, or pasting text onto the TextField). This condition
    // fixes a problem where a character wasn't properly erased after a
    // backspace press, when this Flutter bug was present. This comes at the
    // cost of losing insertion/removal in the middle and pasting text.
    // if (!isInsertedCharacter && !isRemovedCharacter) {
    //   return oldValue;
    // }

    if (enableNegative) {
      _isNegative = newValue.text.startsWith('-');
    } else {
      _isNegative = false;
    }

    String newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    // If the user wants to remove a digit, but the last character of the
    // formatted text is not a digit (for example, "1,00 €"), we need to remove
    // the digit manually.
    if (isRemovedCharacter && !_lastCharacterIsDigit(oldValue.text)) {
      final int length = newText.length - 1;
      newText = newText.substring(0, length > 0 ? length : 0);
    }

    numberFormatter(newText);

    if (_isLessThanMinValue() || _isMoreThanMaxValue()) {
      return oldValue;
    }

    if (newText.trim() == '' || newText == '00' || newText == '000') {
      return TextEditingValue(
        text: _isNegative ? '-' : '',
        selection: TextSelection.collapsed(offset: _isNegative ? 1 : 0),
      );
    }

    /// Call onChange callback
    if (onChange != null) {
      onChange!(_newString);
    }

    return TextEditingValue(
      text: _newString,
      selection: TextSelection.collapsed(offset: _newString.length),
    );
  }

  static bool _lastCharacterIsDigit(String text) {
    final String lastChar = text.substring(text.length - 1);
    return RegExp('[0-9]').hasMatch(lastChar);
  }

  /// Get String type value with format such as `$ 2,000.00`
  String getFormattedValue() {
    return _newString;
  }

  /// Get num type value without format such as `2000.00`
  num getUnformattedValue() {
    return _isNegative ? (_newNum * -1) : _newNum;
  }

  /// Method for formatting value.
  /// You can use initialValue with this method.
  String format(String value) {
    if (enableNegative) {
      _isNegative = value.startsWith('-');
    } else {
      _isNegative = false;
    }

    final String newText = value.replaceAll(RegExp('[^0-9]'), '');
    numberFormatter(newText);
    return _newString;
  }

  /// Method for formatting value.
  /// You can use initialValue(double) with this method.
  String formatDouble(double value) {
    if (enableNegative) {
      _isNegative = value.isNegative;
    } else {
      _isNegative = false;
    }

    final String newText = value
        .toStringAsFixed(numberFormat.decimalDigits ?? 0)
        .replaceAll(RegExp('[^0-9]'), '');
    numberFormatter(newText);
    return _newString;
  }

  /// get double value
  double getDouble() {
    return getUnformattedValue().toDouble();
  }
}

/// Enum for input direction.
enum InputDirection {
  /// Left input direction
  left,

  /// Right input direction
  right,
}
