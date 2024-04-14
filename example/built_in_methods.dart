import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final CurrencyTextInputFormatter formatter =
      CurrencyTextInputFormatter.currency();

  @override
  Widget build(BuildContext context) {
    // Built-in Methods
    print(formatter.getFormattedValue()); // $ 2,000
    print(formatter.getUnformattedValue()); // 2000.00
    print(formatter.formatString('2000')); // $ 2,000

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: Center(
          child: TextField(
            inputFormatters: <TextInputFormatter>[
              formatter,
            ],
            keyboardType: TextInputType.number,
          ),
        ),
      ),
    );
  }
}
