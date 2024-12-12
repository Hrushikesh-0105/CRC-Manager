import 'package:flutter/material.dart';

class ColorCodedLegend extends StatelessWidget {
  const ColorCodedLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildLegendItem(Colors.orangeAccent, 'Booked'),
        const SizedBox(width: 8),
        _buildLegendItem(Colors.redAccent, 'In Use'),
        const SizedBox(width: 8),
        _buildLegendItem(Colors.grey, 'Free'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
