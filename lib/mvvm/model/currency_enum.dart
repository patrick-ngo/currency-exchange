enum Currency {
  usd,
  sgd,
  jpy,
  eur,
}

extension CurrencyExtension on Currency {
  String get currencySymbol {
    switch (this) {
      case Currency.usd:
        return 'USD';
      case Currency.sgd:
        return 'SGD';
      case Currency.jpy:
        return 'JPY';
      case Currency.eur:
        return 'EUR';
      default:
        return '';
    }
  }

  String get flag {
    switch (this) {
      case Currency.usd:
        return '🇺🇸';
      case Currency.sgd:
        return '🇸🇬';
      case Currency.jpy:
        return '🇯🇵';
      case Currency.eur:
        return '🇪🇺';
      default:
        return '';
    }
  }

  String get displayName {
    switch (this) {
      case Currency.usd:
        return 'US Dollar';
      case Currency.sgd:
        return 'Singapore Dollar';
      case Currency.jpy:
        return 'Japanese Yen';
      case Currency.eur:
        return 'Euro';
      default:
        return '';
    }
  }
}
