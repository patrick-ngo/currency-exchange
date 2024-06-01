import 'package:currency_exchange/api/model/currency_api_response.dart';
import 'package:currency_exchange/mvvm/model/currency_enum.dart';
import 'package:currency_exchange/mvvm/model/time_period_enum.dart';
import 'package:currency_exchange/mvvm/currency_main_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockICurrencyAPIService mockApiService;
  late ICurrencyMainViewModel viewModel;

  setUp(() {
    mockApiService = MockICurrencyAPIService();
    when(mockApiService.fetchCurrencyData(
      startDate: anyNamed('startDate'),
      endDate: anyNamed('endDate'),
      fromCurrency: anyNamed('fromCurrency'),
      toCurrency: anyNamed('toCurrency'),
    )).thenAnswer((_) async => CurrencyApiResponse(
          fromCurrency: 'USD',
          toCurrency: 'SGD',
          data: [],
          trend: 0.0,
        ));
    viewModel = CurrencyMainViewModel(apiService: mockApiService);
  });

  group('CurrencyMainViewModel', () {
    test('initial state is correct', () {
      expect(viewModel.selectedFromCurrency, Currency.usd);
      expect(viewModel.selectedToCurrency, Currency.sgd);
      expect(viewModel.selectedTimePeriod, TimePeriod.oneWeek);
      expect(viewModel.selectedDateRange, isNull);
      expect(viewModel.chartData, isEmpty);
      expect(viewModel.selectedValueDifference, 0.0);
    });

    test('fetchCurrencyData updates chartData and selectedValueDifference',
        () async {
      // Given
      final now = DateTime.now();
      final response = CurrencyApiResponse(
        fromCurrency: 'USD',
        toCurrency: 'SGD',
        data: [
          CurrencyDataPoint(
              date: now.subtract(const Duration(days: 6)), rate: 1.1),
          CurrencyDataPoint(
              date: now.subtract(const Duration(days: 5)), rate: 1.2),
          CurrencyDataPoint(
              date: now.subtract(const Duration(days: 4)), rate: 1.3),
          CurrencyDataPoint(
              date: now.subtract(const Duration(days: 3)), rate: 1.4),
          CurrencyDataPoint(
              date: now.subtract(const Duration(days: 2)), rate: 1.5),
          CurrencyDataPoint(
              date: now.subtract(const Duration(days: 1)), rate: 1.6),
          CurrencyDataPoint(date: now, rate: 1.7),
        ],
        trend: 1.0,
      );

      when(mockApiService.fetchCurrencyData(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        fromCurrency: anyNamed('fromCurrency'),
        toCurrency: anyNamed('toCurrency'),
      )).thenAnswer((_) async => response);

      // When
      viewModel.selectTimePeriod(TimePeriod.oneWeek);
      await Future.delayed(const Duration(milliseconds: 100));

      // Then
      expect(viewModel.chartData.length, 7);
      expect(viewModel.chartData.first.y, 1.1);
      expect(viewModel.selectedValueDifference, 1.0);
      verify(mockApiService.fetchCurrencyData(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        fromCurrency: anyNamed('fromCurrency'),
        toCurrency: anyNamed('toCurrency'),
      )).called(2);
    });

    test('selectFromCurrency updates selectedFromCurrency and fetches data',
        () async {
      // Given
      final response = CurrencyApiResponse(
        fromCurrency: 'JPY',
        toCurrency: 'SGD',
        data: [],
        trend: 0.0,
      );

      when(mockApiService.fetchCurrencyData(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        fromCurrency: anyNamed('fromCurrency'),
        toCurrency: anyNamed('toCurrency'),
      )).thenAnswer((_) async => response);

      // When
      viewModel.selectFromCurrency(Currency.jpy);
      await Future.delayed(Duration.zero);

      // Then
      expect(viewModel.selectedFromCurrency, Currency.jpy);
      verify(mockApiService.fetchCurrencyData(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        fromCurrency: Currency.jpy,
        toCurrency: viewModel.selectedToCurrency,
      )).called(1);
    });

    // Add more tests for other methods as needed
  });
}
