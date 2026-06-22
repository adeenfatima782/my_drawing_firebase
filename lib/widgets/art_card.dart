// lib/widgets/art_card.dart
import 'package:flutter/material.dart';
import '../models/drawing_model.dart';

class ArtCard extends StatelessWidget {
  final DrawingModel drawing;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Widget? trailing;

  const ArtCard({super.key, required this.drawing, this.onTap, this.onDelete, this.trailing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: drawing.imageUrl != null
                    ? Image.network(drawing.imageUrl!, fit: BoxFit.cover)
                    : Container(
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        _friendlyDate(drawing.createdAt),
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      )),
                  if (trailing != null) trailing!,
                  IconButton(icon: const Icon(Icons.delete_outline, size: 20), onPressed: onDelete),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _friendlyDate(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
