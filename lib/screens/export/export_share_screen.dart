import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ExportShareScreen extends StatelessWidget {
  // Farz karein aapki image bytes yahan pass ho rahi hain
  final Uint8List? imageBytes;

  const ExportShareScreen({super.key, this.imageBytes});

  // --- Gallery mein Save karne ka function ---
  Future<void> _saveToGallery(BuildContext context) async {
    if (imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image found to save!")),
      );
      return;
    }

    // Permission check karna
    var status = await Permission.storage.request();
    if (status.isGranted || await Permission.photos.request().isGranted) {
      final result = await ImageGallerySaver.saveImage(
        imageBytes!,
        quality: 100,
        name: "Drawing_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image saved to Gallery!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save image.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission Denied!")),
      );
    }
  }

  // --- Social Media par share karne ka function ---
  Future<void> _shareImage() async {
    if (imageBytes == null) return;

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/shared_art.png').create();
    await file.writeAsBytes(imageBytes!);

    await Share.shareXFiles([XFile(file.path)], text: 'Check out my drawing!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Export & Share")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Export Format",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Wrap(
                spacing: 12,
                children: [
                  Chip(label: Text("PNG")),
                  Chip(label: Text("JPG")),
                  Chip(label: Text("Transparent PNG"))
                ]
            ),
            const SizedBox(height: 40),

            // Save Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () => _saveToGallery(context),
              child: const Text("Save to Device", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 15),

            // Share Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _shareImage,
              icon: const Icon(Icons.share),
              label: const Text("Share with Friends"),
            ),
          ],
        ),
      ),
    );
  }
}