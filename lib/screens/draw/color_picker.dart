import 'package:flutter/material.dart';

class ColorPickerWidget extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    // 🌈 Define some beautiful pastel colors
    final colors = [
      Colors.black,
      Colors.grey[700]!,
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.amberAccent,
      Colors.lightGreen,
      Colors.lightBlue,
      Colors.tealAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
    ];

    return Row(
      children: [
        for (final color in colors)
          GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedColor == color ? Colors.black : Colors.white,
                  width: 2,
                ),
              ),
              width: 28,
              height: 28,
            ),
          ),
      ],
    );
  }
}
