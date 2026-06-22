import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/drawing_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ===========================
  // USER AUTHENTICATION
  // ===========================

  Future<UserModel> signUp(String username, String email, String password) async {
    try {
      final res = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = res.user!.uid;

      final user = UserModel(
        id: uid,
        username: username,
        email: email,
      );

      await _db.collection('users').doc(uid).set(user.toJson());
      return user;
    } catch (e) {
      debugPrint("SignUp Error: $e");
      rethrow;
    }
  }

  Future<UserModel?> signIn(String email, String password) async {
    try {
      final res = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = res.user!.uid;
      final doc = await _db.collection('users').doc(uid).get();

      if (!doc.exists) {
        debugPrint("User document not found in Firestore!");
        return null;
      }

      final data = doc.data()!;
      return UserModel.fromJson({'id': uid, ...data});
    } catch (e) {
      debugPrint("SignIn Error: $e");
      rethrow;
    }
  }

  Future<UserModel?> currentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint("No active session found in Firebase Auth.");
        return null;
      }

      final doc = await _db.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        debugPrint("User doc missing for UID: ${user.uid}");
        return null;
      }

      final data = doc.data()!;
      return UserModel.fromJson({'id': user.uid, ...data});
    } catch (e) {
      debugPrint("currentUser Fetch Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ===========================
  // CLOUDINARY TO FIRESTORE (New Function)
  // ===========================

  /// Ye function Cloudinary ka link Firestore mein save karta hai
  Future<void> saveDrawingToFirestore({required String imageUrl, required String ownerId}) async {
    try {
      await _db.collection('drawings').add({
        'imageUrl': imageUrl,
        'ownerId': ownerId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint("Firestore Success: Cloudinary link saved!");
    } catch (e) {
      debugPrint("Firestore Save Error: $e");
      rethrow;
    }
  }

  // ===========================
  // STORAGE (Purana - Ab Cloudinary use ho raha hai)
  // ===========================
  Future<String> uploadBytesToStorage(Uint8List bytes, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final metadata = SettableMetadata(contentType: 'image/png');
      await ref.putData(bytes, metadata);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("Storage Upload Error: $e");
      rethrow;
    }
  }

  // ===========================
  // DRAWINGS CRUD
  // ===========================
  Future<String> addDrawing(DrawingModel drawing) async {
    try {
      final doc = await _db.collection('drawings').add(drawing.toJson());
      return doc.id;
    } catch (e) {
      debugPrint("Add Drawing Error: $e");
      rethrow;
    }
  }

  Future<List<DrawingModel>> fetchUserDrawings(String uid) async {
    try {
      if (uid.isEmpty) return [];

      final snap = await _db
          .collection('drawings')
          .where('ownerId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snap.docs
          .map((d) => DrawingModel.fromJson(d.id, d.data()))
          .toList();
    } catch (e) {
      debugPrint("Fetch Drawings Error: $e");
      return [];
    }
  }

  Future<void> updateDrawing(String id, Map<String, dynamic> changes) async {
    try {
      await _db.collection('drawings').doc(id).update(changes);
    } catch (e) {
      debugPrint("Update Drawing Error: $e");
      rethrow;
    }
  }

  Future<void> deleteDrawing(String id) async {
    try {
      await _db.collection('drawings').doc(id).delete();
    } catch (e) {
      debugPrint("Delete Drawing Error: $e");
      rethrow;
    }
  }
}