// lib/widgets/tool_card.dart
import 'package:flutter/material.dart';
import 'glass_container.dart';

class ToolCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final String description;
  final VoidCallback onTap;

  const ToolCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        radius: 18,
        padding: const EdgeInsets.all(0),
        onTap: onTap, // ensures tapping anywhere triggers callback
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 56,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.image_not_supported, size: 56, color: Colors.white54),
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
