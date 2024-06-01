import 'package:currency_exchange/mvvm/model/currency_enum.dart';
import 'package:currency_exchange/api/currency_api_service.dart';
import 'package:currency_exchange/mvvm/model/time_period_enum.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

abstract class ICurrencyMainViewModel extends ChangeNotifier {
  Currency get selectedFromCurrency;
  Currency get selectedToCurrency;
  TimePeriod get selectedTimePeriod;
  DateTimeRange? get selectedDateRange;
  double get selectedValueDifference;
  List<FlSpot> get chartData;

  void selectFromCurrency(Currency currency);
  void selectToCurrency(Currency currency);
  void selectTimePeriod(TimePeriod period);
  void updateDateRange(DateTime start, DateTime end);
  void swapCurrencies();
  void updateTouchedValue(double? value);
}

class CurrencyMainViewModel extends ChangeNotifier
    implements ICurrencyMainViewModel {
  final ICurrencyAPIService apiService;

  CurrencyMainViewModel({required this.apiService}) {
    _fetchCurrencyData(); // Fetch currency data when the view model is initialized
  }

  Currency _selectedFromCurrency = Currency.usd;
  Currency _selectedToCurrency = Currency.sgd;
  TimePeriod _selectedTimePeriod = TimePeriod.oneWeek;
  DateTimeRange? _selectedDateRange;
  List<FlSpot> _chartData = [];
  double _selectedValueDifference = 0.0;

  @override
  Currency get selectedFromCurrency => _selectedFromCurrency;
  @override
  Currency get selectedToCurrency => _selectedToCurrency;
  @override
  TimePeriod get selectedTimePeriod => _selectedTimePeriod;
  @override
  DateTimeRange? get selectedDateRange => _selectedDateRange;
  @override
  List<FlSpot> get chartData => _chartData;
  @override
  double get selectedValueDifference => _selectedValueDifference;

  @override
  void selectFromCurrency(Currency? currency) {
    if (currency != null && currency != _selectedToCurrency) {
      _selectedFromCurrency = currency;
      _fetchCurrencyData();
      notifyListeners();
    }
  }

  @override
  void selectToCurrency(Currency? currency) {
    if (currency != null && currency != _selectedFromCurrency) {
      _selectedToCurrency = currency;
      _fetchCurrencyData();
      notifyListeners();
    }
  }

  @override
  void swapCurrencies() {
    final temp = _selectedFromCurrency;
    _selectedFromCurrency = _selectedToCurrency;
    _selectedToCurrency = temp;
    _fetchCurrencyData();
    notifyListeners();
  }

  @override
  void selectTimePeriod(TimePeriod period) {
    _selectedTimePeriod = period;
    _selectedDateRange = null; // Clear custom date range if any
    _fetchCurrencyData();
    notifyListeners();
  }

  @override
  void updateTouchedValue(double? value) {
    notifyListeners();
  }

  @override
  void updateDateRange(DateTime start, DateTime end) {
    _selectedDateRange = DateTimeRange(start: start, end: end);
    _selectedTimePeriod = TimePeriod.custom;
    _fetchCurrencyData();
    notifyListeners();
  }

  Future<void> _fetchCurrencyData() async {
    DateTime startDate;
    DateTime endDate;

    switch (_selectedTimePeriod) {
      case TimePeriod.oneWeek:
        startDate = DateTime.now().subtract(const Duration(days: 7));
        endDate = DateTime.now();
        break;
      case TimePeriod.oneMonth:
        startDate = DateTime.now().subtract(const Duration(days: 30));
        endDate = DateTime.now();
        break;
      case TimePeriod.sixMonths:
        startDate = DateTime.now().subtract(const Duration(days: 180));
        endDate = DateTime.now();
        break;
      case TimePeriod.custom:
        if (_selectedDateRange != null) {
          startDate = _selectedDateRange!.start;
          endDate = _selectedDateRange!.end;
        } else {
          return;
        }
        break;
    }

    final response = await apiService.fetchCurrencyData(
      fromCurrency: _selectedFromCurrency,
      toCurrency: _selectedToCurrency,
      startDate: startDate,
      endDate: endDate,
    );

    _chartData = response.data.map((point) {
      final date = point.date;
      final value = point.rate;
      return FlSpot(date.difference(startDate).inDays.toDouble(), value);
    }).toList();

    _selectedValueDifference = response.trend;

    notifyListeners();
  }
}
