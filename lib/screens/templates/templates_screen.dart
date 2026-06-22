// lib/screens/templates/templates_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/glass_container.dart';

class TemplatesScreen extends StatelessWidget {
  TemplatesScreen({super.key});

  final List<String> templates = const [
    "Faces",
    "Mandalas",
    "Shapes",
    "Animals",
    "Anime",
    "Portrait Guides",
    "Landscape",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drawing Templates")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.builder(
          itemCount: templates.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // TODO: Open the selected template in the canvas
              },
              child: GlassContainer(
                radius: 20, // required radius
                child: Center(
                  child: Text(
                    templates[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // better visibility on glass
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
