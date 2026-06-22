import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:my_drawing_firebase/services/ai_service.dart';
import '../services/cloudinary_service.dart';
import '../services/firebase_service.dart';
import '../models/drawing_model.dart';

class DrawingController extends ChangeNotifier {
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final FirebaseService _firebaseService = FirebaseService();

  List<DrawingModel> _drawings = [];
  bool _loading = false;

  // Getters (GalleryScreen inko use karti hai)
  List<DrawingModel> get drawings => _drawings;
  bool get loading => _loading;

  DrawingController(FirebaseService firebaseService, CloudinaryService cloudinaryService, AIService aiService);

  Future<void> loadUserDrawings(String uid) async {
    if (uid.isEmpty) return;
    _loading = true;
    notifyListeners();
    try {
      _drawings = await _firebaseService.fetchUserDrawings(uid);
    } catch (e) {
      debugPrint("Load Error: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> saveDrawing({required Uint8List bytes, String? ownerId}) async {
    if (ownerId == null) return;
    try {
      final String? imageUrl = await _cloudinaryService.uploadImage(bytes);
      if (imageUrl != null) {
        await _firebaseService.saveDrawingToFirestore(imageUrl: imageUrl, ownerId: ownerId);
        await loadUserDrawings(ownerId);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDrawing(String id) async {
    try {
      await _firebaseService.deleteDrawing(id);
      _drawings.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
  }

  Future<void> enhanceImage(Uint8List bytes) async {
    notifyListeners();
  }
}