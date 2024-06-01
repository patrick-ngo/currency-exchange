import 'package:currency_exchange/common/colors.dart';
import 'package:currency_exchange/mvvm/model/time_period_enum.dart';
import 'package:flutter/material.dart';

class CurrencyPeriodSelectorView extends StatelessWidget {
  final TimePeriod selectedPeriod;
  final ValueChanged<TimePeriod> onPeriodSelected;
  final VoidCallback onCalendarPressed;

  const CurrencyPeriodSelectorView({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodSelected,
    required this.onCalendarPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Exclude TimePeriod.custom from both the children and isSelected lists
    final periods = TimePeriod.values
        .where((period) => period != TimePeriod.custom)
        .toList();
    final isSelected =
        periods.map((period) => period == selectedPeriod).toList();

    return Row(
      children: [
        ToggleButtons(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          isSelected: isSelected,
          onPressed: (index) {
            onPeriodSelected(periods[index]);
          },
          children: periods.map((period) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(period.displayName,
                  style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.grey950,
                      fontWeight: FontWeight.normal)),
            );
          }).toList(),
        ),
        const SizedBox(width: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey300, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ),
          child: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: onCalendarPressed,
            color: selectedPeriod == TimePeriod.custom
                ? Theme.of(context).primaryColor
                : AppColors.grey500,
          ),
        ),
      ],
    );
  }
}
