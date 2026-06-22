// lib/services/drawing_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class DrawingService {
  static Future<String> savePngBytes(Uint8List bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/drawings');
    if (!await folder.exists()) await folder.create(recursive: true);
    final filename = 'drawing_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('${folder.path}/$filename');
    await file.writeAsBytes(bytes);
    return file.path;
  }
  static Future<Uint8List?> aiEnhanceImage(Uint8List bytes) async {
    // TODO: integrate real AI model
    await Future.delayed(Duration(milliseconds: 800));
    return bytes; // return same image for now
  }

}
