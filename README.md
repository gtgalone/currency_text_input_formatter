# Currency Text Input Formatter

[![pub package](https://img.shields.io/pub/v/currency_text_input_formatter.svg)](https://pub.dartlang.org/packages/currency_text_input_formatter)

Currency Text Input Formatter for Flutter.
https://pub.dev/packages/currency_text_input_formatter

## Installation

### Add pubspec.yaml
``` yaml
dependencies:
  currency_text_input_formatter: ^2.1.14
```
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
            inputFormatters: [CurrencyTextInputFormatter()],
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
  State<YellowBird> createState() => _MyFormFieldState();
}

class _MyFormFieldState extends State<MyFormField> {
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: _formatter.format('2000'),
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
              CurrencyTextInputFormatter(
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
  State<YellowBird> createState() => _MyFormFieldState();
}

class _MyFormFieldState extends State<MyFormField> {
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter();

  @override
  Widget build(BuildContext context) {
    // Built-in Methods
    print(formatter.getFormattedValue()); // $ 2,000
    print(formatter.getUnformattedValue()); // 2000.00
    print(formatter.format('2000')); // $ 2,000
    print(formatter.formatDouble('20.00')); // $ 20

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
