import 'package:currency_exchange/common/colors.dart';
import 'package:currency_exchange/mvvm/model/time_period_enum.dart';
import 'package:currency_exchange/mvvm/model/currency_enum.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class CurrencyChartView extends StatelessWidget {
  final Currency fromCurrency;
  final Currency toCurrency;
  final List<FlSpot> chartData;
  final ValueChanged<double?> onTouchedValueChanged;
  final TimePeriod selectedPeriod;
  final double selectedValueDifference;

  const CurrencyChartView({
    super.key,
    required this.fromCurrency,
    required this.toCurrency,
    required this.chartData,
    required this.onTouchedValueChanged,
    required this.selectedPeriod,
    required this.selectedValueDifference,
  });

  @override
  Widget build(BuildContext context) {
    final valueDifferenceText = selectedValueDifference.toStringAsFixed(2);
    final valueDifferenceDisplay = selectedValueDifference > 0
        ? '+$valueDifferenceText%'
        : '$valueDifferenceText%';
    final valueDifferenceColor =
        selectedValueDifference > 0 ? Colors.green : Colors.red;
    final selectedPeriodDisplay =
        '(${selectedPeriod.displayName})'.toLowerCase();

    final DateFormat dateFormat = DateFormat('MMM d, yyyy, HH:mm \'UTC\'');
    final DateFormat bottomTitleDateFormat = DateFormat('MMM d');

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop)
              Row(
                children: [
                  Text(
                    '${fromCurrency.currencySymbol} to ${toCurrency.currencySymbol} Chart',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey950),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    valueDifferenceDisplay,
                    style: TextStyle(
                        color: valueDifferenceColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedPeriodDisplay,
                    style: const TextStyle(
                        color: AppColors.grey950,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                  const Spacer(),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${fromCurrency.currencySymbol} to ${toCurrency.currencySymbol} Chart',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey950),
                  ),
                  Row(children: [
                    Text(
                      valueDifferenceDisplay,
                      style: TextStyle(color: valueDifferenceColor),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedPeriodDisplay,
                      style: const TextStyle(
                          color: AppColors.grey950,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ])
                ],
              ),
            Text('${fromCurrency.displayName} to ${toCurrency.displayName}'),
            const SizedBox(height: 24),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true), // Show gridlines
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(
                      getTextStyles: (context, value) =>
                          const TextStyle(color: AppColors.grey400),
                      showTitles: true,
                      reservedSize: 40,
                    ),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      getTextStyles: (context, value) =>
                          const TextStyle(color: AppColors.grey400),
                      showTitles: true,
                      reservedSize: 22,
                      interval: selectedPeriod.interval,
                      getTitles: (value) {
                        final date = DateTime.now().subtract(Duration(
                            days: (6 - value.toInt()) *
                                selectedPeriod.interval.toInt()));
                        return bottomTitleDateFormat.format(date);
                      },
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(color: Colors.black, width: 1),
                      left: BorderSide.none,
                      right: BorderSide.none,
                      top: BorderSide.none,
                    ),
                  ),
                  lineBarsData: chartData.isEmpty
                      ? []
                      : [
                          LineChartBarData(
                            spots: chartData,
                            isCurved: true,
                            colors: [Colors.blue],
                            barWidth: 2,
                            belowBarData: BarAreaData(show: false),
                            dotData: FlDotData(
                                show: false), // Hide the circular points
                          ),
                        ],
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.white,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final date = DateTime.now().subtract(Duration(
                              days: (6 - touchedSpot.x.toInt()) *
                                  selectedPeriod.interval.toInt()));
                          final formattedDate = dateFormat.format(date.toUtc());
                          return LineTooltipItem(
                            touchedSpot.y.toStringAsFixed(6),
                            const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: '\n$formattedDate',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                    touchCallback:
                        (FlTouchEvent event, LineTouchResponse? touchResponse) {
                      onTouchedValueChanged(
                          touchResponse?.lineBarSpots?.first.y);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
