import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formatter = CurrencyTextInputFormatter.currency(symbol: '\$ ');
  final _controller = TextEditingController();
  // Formatters keep state, so each field needs its own instance.
  final _cursorFormatter = CurrencyTextInputFormatter.currency(
    symbol: '\$ ',
    maintainCursorPosition: true,
  );
  final _cursorController = TextEditingController();

  void initState() {
    super.initState();
    _controller.text = _formatter.formatString('0.0');
    _cursorController.text = _cursorFormatter.formatString('0.0');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: SizedBox(
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  inputFormatters: [_formatter],
                  decoration: InputDecoration(
                    label: Text('maintainCursorPosition = false'),
                    hint: Text('Hint'),
                  ),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _cursorController,
                  inputFormatters: [_cursorFormatter],
                  decoration: InputDecoration(
                    label: Text('maintainCursorPosition = true'),
                    hint: Text('Hint'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
