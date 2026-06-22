import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';

class AuthController with ChangeNotifier {
  final FirebaseService _service;

  // Constructor
  AuthController(this._service) {
    // App khulte hi user load karne ki koshish karein
    _init();
  }

  bool _loading = false;
  String? _error;
  UserModel? _currentUser;

  // Getters
  bool get loading => _loading;
  String? get error => _error;
  UserModel? get currentUser => _currentUser;

  // Initialize function jo check karega ke user pehle se logged in hai ya nahi
  Future<void> _init() async {
    _loading = true;
    notifyListeners();

    // Firebase Auth se check karein ke session active hai?
    final user = await _service.currentUser();
    if (user != null) {
      _currentUser = user;
    }

    _loading = false;
    notifyListeners();
  }

  // 1. SIGN IN
  Future<bool> signIn(String email, String password) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final user = await _service.signIn(email, password);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        return true;
      } else {
        throw Exception('Login failed. Please check credentials.');
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // 2. SIGN UP
  Future<bool> signUp(String name, String email, String password) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final user = await _service.signUp(name, email, password);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // 3. LOAD CURRENT USER (Profile screen ke liye)
  Future<void> loadCurrentUser() async {
    try {
      final user = await _service.currentUser();
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Load User Error: $e");
    }
  }

  // 4. SIGN OUT
  Future<void> signOut() async {
    await _service.signOut();
    _currentUser = null;
    notifyListeners();
  }
}