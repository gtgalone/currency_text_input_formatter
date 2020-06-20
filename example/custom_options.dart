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
              symbol: 'KRW(원) ',
            )],
            keyboardType: TextInputType.number,
          ),
        ),
      ),
    );
  }
}
