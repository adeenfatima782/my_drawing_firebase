import 'dart:convert';
import 'dart:typed_data'; // Bytes ke liye zaroori import
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class CloudinaryService {
  final String uploadUrl;
  final String uploadPreset;

  CloudinaryService({String? uploadUrl, String? uploadPreset})
      : uploadUrl = uploadUrl ?? cloudinaryUploadUrl,
        uploadPreset = uploadPreset ?? cloudinaryUploadPreset;

  // File ki jagah Uint8List use karein taake Web par error na aaye
  Future<String?> uploadImage(Uint8List imageBytes) async {
    try {
      final uri = Uri.parse(uploadUrl);
      final req = http.MultipartRequest('POST', uri);

      // Sahi field name 'upload_preset' hai
      req.fields['upload_preset'] = uploadPreset;

      // Web compatibility ke liye MultipartFile.fromBytes use karein
      req.files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'drawing_${DateTime.now().millisecondsSinceEpoch}.png',
      ));

      final streamed = await req.send();
      final resp = await http.Response.fromStream(streamed);

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final data = jsonDecode(resp.body);
        return data['secure_url'] ?? data['url'];
      } else {
        throw Exception('Cloudinary upload failed: ${resp.statusCode} ${resp.body}');
      }
    } catch (e) {
      print("Cloudinary Error: $e");
      rethrow;
    }
  }
}