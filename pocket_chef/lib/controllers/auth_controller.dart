import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  bool isLoading = false;
  String errorMessage = '';

  // Login
  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Cadastro
  Future<bool> register(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}