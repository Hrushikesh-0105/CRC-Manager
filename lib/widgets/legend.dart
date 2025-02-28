import 'package:auto_size_text/auto_size_text.dart';
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
    return Container(
      // width: 20,
      height: 20,
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: AutoSizeText(
          label,
          maxLines: 1,
          style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
