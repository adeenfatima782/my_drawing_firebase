import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageFilters {
  static Future<Uint8List> applyBrightness(Uint8List bytes, int amount) async {
    final image = img.decodeImage(bytes)!;
    final updated = img.adjustColor(image, brightness: amount);
    return Uint8List.fromList(img.encodePng(updated));
  }

  static Future<Uint8List> applyContrast(Uint8List bytes, int amount) async {
    final image = img.decodeImage(bytes)!;
    final updated = img.adjustColor(image, contrast: amount);
    return Uint8List.fromList(img.encodePng(updated));
  }

  static Future<Uint8List> applySaturation(Uint8List bytes, int amount) async {
    final image = img.decodeImage(bytes)!;
    final updated = img.adjustColor(image, saturation: amount);
    return Uint8List.fromList(img.encodePng(updated));
  }

  static Future<Uint8List> applyPreset(Uint8List bytes, String preset) async {
    final image = img.decodeImage(bytes)!;
    img.Image out = image.clone();
    switch (preset) {
      case 'Vibrant':
        out = img.adjustColor(out, saturation: 30, contrast: 10);
        break;
      case 'Vintage':
        out = img.grayscale(out);
        out = img.adjustColor(out, brightness: -5, contrast: -5);
        break;
      case 'Pastel':
        out = img.adjustColor(out, saturation: 10, brightness: 5);
        break;
      case 'Mono':
        out = img.grayscale(out);
        break;
      case 'Cartoon':
        out = img.gaussianBlur(out, radius: 1);
        out = img.adjustColor(out, contrast: 20);
        break;
    }
    return Uint8List.fromList(img.encodePng(out));
  }
}
