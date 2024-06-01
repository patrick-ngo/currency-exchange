import 'package:flutter/material.dart';

class CurrencySelectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: 'From'),
          items: [
            DropdownMenuItem(child: Text('USD - US Dollar'), value: 'USD'),
            // Add more currencies as needed
          ],
          onChanged: (value) {},
        ),
        SizedBox(height: 16),
        Icon(Icons.swap_vert),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: 'To'),
          items: [
            DropdownMenuItem(child: Text('EUR - Euro'), value: 'EUR'),
            // Add more currencies as needed
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }
}
