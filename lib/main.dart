import 'package:currency_exchange/api/currency_api_service.dart';
import 'package:currency_exchange/mvvm/currency_main_screen.dart';
import 'package:currency_exchange/mvvm/currency_main_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ICurrencyMainViewModel>(
            create: (_) =>
                CurrencyMainViewModel(apiService: CurrencyAPIService())),
      ],
      child: MaterialApp(
        title: 'Currency Exchange',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const CurrencyMainScreen(),
      ),
    );
  }
}
