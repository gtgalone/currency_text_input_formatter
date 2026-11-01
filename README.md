# Currency Text Input Formatter

[![pub package](https://img.shields.io/pub/v/currency_text_input_formatter.svg)](https://pub.dartlang.org/packages/currency_text_input_formatter)

Currency Text Input Formatter for Flutter.
https://pub.dev/packages/currency_text_input_formatter

## Installation

### Solving Intl package conflict
Add this code end of pubspec.yaml.
``` yaml
dependency_overrides:
  intl: your intl package version
```

---
## Usage

### Basic
``` dart
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: TextField(
            inputFormatters: [CurrencyTextInputFormatter.currency()],
            // inputFormatters: [CurrencyTextInputFormatter.simpleCurrency()], < for simple
            // inputFormatters: [CurrencyTextInputFormatter()], < for basic
            keyboardType: TextInputType.number,
          ),
        ),
      ),
    );
  }
}
```

### With initialValue
``` dart
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: Center(
          child: MyFormField(),
        ),
      ),
    );
  }
}

class MyFormField extends StatefulWidget {
  const MyFormField({ super.key });

  @override
  State<MyFormField> createState() => _MyFormFieldState();
}

class _MyFormFieldState extends State<MyFormField> {
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter.currency();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: _formatter.formatString('2000'),
      inputFormatters: <TextInputFormatter>[_formatter],
      keyboardType: TextInputType.number,
    );
  }
}
```

### Custom Options
``` dart
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: Center(
          child: TextField(
            inputFormatters: <TextInputFormatter>[
              CurrencyTextInputFormatter.currency(
                locale: 'ko',
                decimalDigits: 0,
                symbol: 'KRW(원) ',
              ),
            ],
            keyboardType: TextInputType.number,
          ),
        ),
      ),
    );
  }
}
```

### Maintain cursor position
By default the cursor jumps to the end of the text after every edit. Set
`maintainCursorPosition: true` to keep it where you are editing, e.g. deleting
the `2` in `123.45` gives `13.45` with the cursor between `1` and `3`, so typing
`9` gives `193.45`.

`maintainCursorPosition` defaults to `false` to keep the previous behavior.
It only applies to `InputDirection.right` (with `InputDirection.left` the
cursor is already kept).

``` dart
TextField(
  inputFormatters: <TextInputFormatter>[
    CurrencyTextInputFormatter.currency(
      symbol: '\$ ',
      maintainCursorPosition: true,
    ),
  ],
  keyboardType: TextInputType.number,
)
```

### With built-in methods
``` dart
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: Center(
          child: MyFormField(),
        ),
      ),
    );
  }
}

class MyFormField extends StatefulWidget {
  const MyFormField({ super.key });

  @override
  State<MyFormField> createState() => _MyFormFieldState();
}

class _MyFormFieldState extends State<MyFormField> {
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter.currency();

  @override
  Widget build(BuildContext context) {
    // Built-in Methods
    print(_formatter.getFormattedValue()); // $ 2,000
    print(_formatter.getUnformattedValue()); // 2000.00
    print(_formatter.formatString('2000')); // $ 2,000
    print(_formatter.formatDouble(20.00)); // $ 20

    return TextFormField(
      inputFormatters: <TextInputFormatter>[_formatter],
      keyboardType: TextInputType.number,
    );
  }
}
```
---
## Recommend Libraries

- [Confirm Dialog](https://github.com/gtgalone/confirm_dialog) - Confirm Dialog Widget for Flutter(JS-LIKE).
- [Prompt Dialog](https://github.com/gtgalone/prompt_dialog) - Prompt Dialog Widget for Flutter(JS-LIKE).
- [Alert Dialog](https://github.com/gtgalone/alert_dialog) - Alert Dialog Widget for Flutter(JS-LIKE).

## Maintainer

- [Jehun Seem](https://github.com/gtgalone)

## License

MIT
