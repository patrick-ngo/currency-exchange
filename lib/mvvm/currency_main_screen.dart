import 'package:currency_exchange/common/colors.dart';
import 'package:currency_exchange/mvvm/view/currency_chart_view.dart';
import 'package:currency_exchange/mvvm/view/currency_dropdown_view.dart';
import 'package:currency_exchange/mvvm/view/currency_period_selector_view.dart';
import 'package:currency_exchange/mvvm/currency_main_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CurrencyMainScreen extends StatelessWidget {
  const CurrencyMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ICurrencyMainViewModel>(context);

    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 600;

              return Column(
                children: [
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CurrencyDropdownView(
                            label: 'From',
                            selectedCurrency: viewModel.selectedFromCurrency,
                            disabledCurrency: viewModel.selectedToCurrency,
                            onChanged: viewModel.selectFromCurrency,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: IconButton(
                              key: const ValueKey('swap_button'),
                              icon: const Icon(Icons.swap_horiz,
                                  color: AppColors.main),
                              onPressed: viewModel.swapCurrencies,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CurrencyDropdownView(
                            label: 'To',
                            selectedCurrency: viewModel.selectedToCurrency,
                            disabledCurrency: viewModel.selectedFromCurrency,
                            onChanged: viewModel.selectToCurrency,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CurrencyDropdownView(
                          label: 'From',
                          selectedCurrency: viewModel.selectedFromCurrency,
                          disabledCurrency: viewModel.selectedToCurrency,
                          onChanged: viewModel.selectFromCurrency,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: IconButton(
                            key: const ValueKey('swap_button'),
                            icon: const Icon(Icons.swap_vert,
                                color: AppColors.main),
                            onPressed: viewModel.swapCurrencies,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CurrencyDropdownView(
                          label: 'To',
                          selectedCurrency: viewModel.selectedToCurrency,
                          disabledCurrency: viewModel.selectedFromCurrency,
                          onChanged: viewModel.selectToCurrency,
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  CurrencyPeriodSelectorView(
                    selectedPeriod: viewModel.selectedTimePeriod,
                    onPeriodSelected: (period) {
                      viewModel.selectTimePeriod(period);
                    },
                    onCalendarPressed: () {
                      _showDateRangePicker(
                        context,
                        viewModel.selectedDateRange,
                        (start, end) => viewModel.updateDateRange(start, end),
                        isDesktop,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: CurrencyChartView(
                      fromCurrency: viewModel.selectedFromCurrency,
                      toCurrency: viewModel.selectedToCurrency,
                      chartData: viewModel.chartData,
                      onTouchedValueChanged: viewModel.updateTouchedValue,
                      selectedPeriod: viewModel.selectedTimePeriod,
                      selectedValueDifference:
                          viewModel.selectedValueDifference,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      )),
    );
  }

  void _showDateRangePicker(
    BuildContext context,
    DateTimeRange? initialDateRange,
    void Function(DateTime start, DateTime end) onConfirm,
    bool isDesktop,
  ) {
    DateTimeRange? selectedRange = initialDateRange;

    if (isDesktop) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: SizedBox(
              width: 400,
              height: 400,
              child: Column(
                children: [
                  Expanded(
                    child: _buildDateRangePicker(
                      selectedRange,
                      onConfirm,
                      (range) => selectedRange = range,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        if (selectedRange != null) {
                          onConfirm(
                            selectedRange!.start,
                            selectedRange!.end,
                          );
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 400,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (selectedRange != null) {
                              onConfirm(
                                selectedRange!.start,
                                selectedRange!.end,
                              );
                            }
                            Navigator.of(context).pop();
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: _buildDateRangePicker(
                        selectedRange,
                        onConfirm,
                        (range) => setState(() {
                          selectedRange = range;
                        }),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  Widget _buildDateRangePicker(
    DateTimeRange? selectedRange,
    void Function(DateTime start, DateTime end) onConfirm,
    ValueChanged<DateTimeRange?> onRangeChanged,
  ) {
    return SfDateRangePicker(
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        if (args.value is PickerDateRange) {
          final PickerDateRange range = args.value;
          onRangeChanged(
            DateTimeRange(
              start: range.startDate!,
              end: range.endDate ?? range.startDate!,
            ),
          );
        }
      },
      selectionMode: DateRangePickerSelectionMode.range,
      initialSelectedRange: PickerDateRange(
        selectedRange?.start,
        selectedRange?.end,
      ),
    );
  }
}
