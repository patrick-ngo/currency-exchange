import 'package:flutter/material.dart';
import 'package:currency_exchange/currency_exchange_screen/currency_exchange_screen.dart';

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CurrencyConverterScreen(),
    );
  }
}
