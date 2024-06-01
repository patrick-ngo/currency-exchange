enum TimePeriod {
  oneWeek,
  oneMonth,
  sixMonths,
  custom,
}

extension TimePeriodExtension on TimePeriod {
  double get interval {
    switch (this) {
      case TimePeriod.oneWeek:
        return 2;
      case TimePeriod.oneMonth:
        return 7;
      case TimePeriod.sixMonths:
        return 30;
      case TimePeriod.custom:
        return 7;
      default:
        return 1;
    }
  }

  String get displayName {
    switch (this) {
      case TimePeriod.oneWeek:
        return '1W';
      case TimePeriod.oneMonth:
        return '1M';
      case TimePeriod.sixMonths:
        return '6M';
      case TimePeriod.custom:
        return 'Custom';
      default:
        return '';
    }
  }
}
