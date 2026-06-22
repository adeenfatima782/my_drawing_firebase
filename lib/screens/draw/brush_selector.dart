import 'package:flutter/material.dart';

class BrushSelectorWidget extends StatelessWidget {
  final double brushSize;
  final ValueChanged<double> onSizeChanged;

  const BrushSelectorWidget({
    super.key,
    required this.brushSize,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.brush, size: 22, color: Colors.grey),
        Slider(
          value: brushSize,
          onChanged: onSizeChanged,
          min: 1.0,
          max: 30.0,
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Colors.grey[300],
          thumbColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
