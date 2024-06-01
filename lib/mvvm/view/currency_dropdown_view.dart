import 'package:currency_exchange/common/colors.dart';
import 'package:currency_exchange/mvvm/model/currency_enum.dart';
import 'package:flutter/material.dart';

class CurrencyDropdownView extends StatelessWidget {
  final String label;
  final Currency selectedCurrency;
  final Currency disabledCurrency;
  final ValueChanged<Currency> onChanged;

  const CurrencyDropdownView({
    super.key,
    required this.label,
    required this.selectedCurrency,
    required this.disabledCurrency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: AppColors.grey950)),
        const SizedBox(height: 4),
        DropdownButtonFormField<Currency>(
          value: selectedCurrency,
          icon: const Icon(null),
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.expand_more, color: AppColors.grey500),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.grey300),
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.grey300),
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
          ),
          items: Currency.values.map((currency) {
            return DropdownMenuItem<Currency>(
              value: currency,
              enabled: currency != disabledCurrency,
              child: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: Row(
                    children: [
                      Text(currency.flag),
                      const SizedBox(width: 8),
                      Text(
                        currency.currencySymbol,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey950),
                      ),
                      const Text(' - '),
                      Text(currency.displayName,
                          style: const TextStyle(color: AppColors.grey500)),
                    ],
                  )),
            );
          }).toList(),
          onChanged: (currency) {
            if (currency != null && currency != disabledCurrency) {
              onChanged(currency);
            }
          },
        ),
      ],
    );
  }
}
