import 'dart:math';
import 'package:currency_exchange/api/model/currency_api_response.dart';
import 'package:currency_exchange/mvvm/model/currency_enum.dart';

abstract class ICurrencyAPIService {
  Future<CurrencyApiResponse> fetchCurrencyData({
    required DateTime startDate,
    required DateTime endDate,
    required Currency fromCurrency,
    required Currency toCurrency,
  });
}

class CurrencyAPIService implements ICurrencyAPIService {
  @override
  Future<CurrencyApiResponse> fetchCurrencyData({
    required DateTime startDate,
    required DateTime endDate,
    required Currency fromCurrency,
    required Currency toCurrency,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate random data for the provided date range
    final daysDifference = endDate.difference(startDate).inDays;
    final random = Random();
    List<CurrencyDataPoint> dataPoints = List.generate(
      daysDifference + 1,
      (index) {
        final date = startDate.add(Duration(days: index));
        return CurrencyDataPoint(
          date: date,
          rate: random.nextDouble() * 100,
        );
      },
    );

    // Generate a random trend value
    final trend =
        (random.nextDouble() - 0.5) * 2; // Random value between -1 and 1

    return CurrencyApiResponse(
      fromCurrency: fromCurrency.toString(),
      toCurrency: toCurrency.toString(),
      data: dataPoints,
      trend: trend,
    );
  }
}
