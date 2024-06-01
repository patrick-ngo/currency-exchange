import 'package:flutter/material.dart';
import 'package:currency_exchange/currency_exchange_screen/view/currency_chart_view.dart';
import 'package:currency_exchange/currency_exchange_screen/view/currency_selection_view.dart';

class CurrencyConverterScreen extends StatelessWidget {
  const CurrencyConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CurrencySelectionView(),
            SizedBox(height: 16),
            CurrencyChartView(),
          ],
        ),
      ),
    );
  }
}
