import 'package:flutter/material.dart';
import '../../models/tool_model.dart';

class ToolDetailPage extends StatelessWidget {
  final ToolModel tool;

  const ToolDetailPage({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tool.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(tool.imagePath, height: 180),
            const SizedBox(height: 20),
            Text(
              tool.description,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
