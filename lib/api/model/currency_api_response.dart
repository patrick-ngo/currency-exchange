class CurrencyDataPoint {
  final DateTime date;
  final double rate;

  CurrencyDataPoint({required this.date, required this.rate});

  factory CurrencyDataPoint.fromJson(Map<String, dynamic> json) {
    return CurrencyDataPoint(
      date: DateTime.parse(json['date']),
      rate: json['rate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'rate': rate,
    };
  }
}

class CurrencyApiResponse {
  final String fromCurrency;
  final String toCurrency;
  final List<CurrencyDataPoint> data;
  final double trend;

  CurrencyApiResponse(
      {required this.fromCurrency,
      required this.toCurrency,
      required this.data,
      required this.trend});

  factory CurrencyApiResponse.fromJson(Map<String, dynamic> json) {
    var dataPoints = (json['data'] as List)
        .map((i) => CurrencyDataPoint.fromJson(i))
        .toList();
    return CurrencyApiResponse(
      fromCurrency: json['fromCurrency'],
      toCurrency: json['toCurrency'],
      data: dataPoints,
      trend: json['trend'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'data': data.map((e) => e.toJson()).toList(),
      'trend': trend,
    };
  }
}
