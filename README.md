# Currency Text Input Formatter

[![pub package](https://img.shields.io/pub/v/currency_text_input_formatter.svg)](https://pub.dartlang.org/packages/currency_text_input_formatter)

Currency Text Input Formatter for Flutter.
https://pub.dev/packages/currency_text_input_formatter

## Installation

### Add pubspec.yaml
``` yaml
dependencies:
  currency_text_input_formatter: ^2.0.1
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
import 'package:flutter/material.dart';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

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

### Custom Options
``` dart
import 'package:flutter/material.dart';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

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
            inputFormatters: [CurrencyTextInputFormatter(
              locale: 'ko',
              decimalDigits: 0,
              symbol: 'KRW(원) ', // or to remove symbol set ''.
            )],
            keyboardType: TextInputType.number,
          ),
        ),
      ),
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
