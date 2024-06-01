import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CurrencyChartView extends StatefulWidget {
  @override
  _CurrencyChartViewState createState() => _CurrencyChartViewState();
}

class _CurrencyChartViewState extends State<CurrencyChartView> {
  double? _touchedValue;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'USD to EUR Chart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '+0.95% (1w)',
            style: TextStyle(color: Colors.green),
          ),
          Text('US Dollar to Euro'),
          SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 0.92),
                      FlSpot(1, 0.93),
                      FlSpot(2, 0.94),
                      FlSpot(3, 0.91),
                      FlSpot(4, 0.94),
                    ],
                    isCurved: true,
                    colors: [Colors.blue],
                    barWidth: 2,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.blueAccent,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        return LineTooltipItem(
                          '${touchedSpot.y}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? touchResponse) {
                    setState(() {
                      if (touchResponse != null &&
                          touchResponse.lineBarSpots != null &&
                          touchResponse.lineBarSpots!.isNotEmpty) {
                        _touchedValue = touchResponse.lineBarSpots![0].y;
                      } else {
                        _touchedValue = null;
                      }
                    });
                  },
                  handleBuiltInTouches: true,
                ),
              ),
            ),
          ),
          if (_touchedValue != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Selected Value: $_touchedValue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
