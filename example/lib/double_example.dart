import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.simpleCurrency(locale: "en-Gb");
    final formatter = CurrencyTextInputFormatter(format);

    String initialValue = formatter.formatDouble(123.25);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Flutter'),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              initialValue: initialValue,
              inputFormatters: <TextInputFormatter>[
                formatter,
              ],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
                onPressed: () async {
                  String doubleValue = formatter
                      .getDouble()
                      .toStringAsFixed(format.decimalDigits ?? 0);

                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text(
                          "The double value from the field is " + doubleValue),
                    ),
                  );
                },
                child: Text("submit")),
          ],
        ),
      ),
    );
  }
}
