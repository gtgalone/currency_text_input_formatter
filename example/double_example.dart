import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CurrencyTextInputFormatter simpleformatter =
        CurrencyTextInputFormatter.simpleCurrency(
      locale: 'en-Gb',
    );
    final CurrencyTextInputFormatter formatter =
        CurrencyTextInputFormatter.simpleCurrency(
      locale: 'ja-JP',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Flutter'),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              initialValue: simpleformatter.formatDouble(123.25),
              inputFormatters: <TextInputFormatter>[
                simpleformatter,
              ],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: formatter.formatDouble(123.25),
              inputFormatters: <TextInputFormatter>[
                formatter,
              ],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                    onPressed: () async {
                      final String doubleValue = simpleformatter
                          .getDouble()
                          .toStringAsFixed(
                              simpleformatter.numberFormat.decimalDigits ?? 0);

                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text(
                              'The double value from the first field is ' +
                                  doubleValue +
                                  ' the formatted value is ' +
                                  simpleformatter.getFormattedValue()),
                        ),
                      );
                    },
                    child: const Text('first field (simpleCurrency)')),
                OutlinedButton(
                    onPressed: () async {
                      final String doubleValue = formatter
                          .getDouble()
                          .toStringAsFixed(
                              formatter.numberFormat.decimalDigits ?? 0);

                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text('The double value from the field is ' +
                              doubleValue +
                              ' the formatted value is ' +
                              formatter.getFormattedValue()),
                        ),
                      );
                    },
                    child: const Text('second field (just currency)')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
