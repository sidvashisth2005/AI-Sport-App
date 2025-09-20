import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthTestService extends ChangeNotifier {
  static FirebaseAuthTestService? _instance;
  static FirebaseAuthTestService get instance => _instance ??= FirebaseAuthTestService._();
  
  FirebaseAuthTestService._() {
    _init();
  }
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get error => _error;
  
  void _init() {
    _currentUser = _auth.currentUser;
    
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }
  
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(name);
        _currentUser = credential.user;
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        _currentUser = credential.user;
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  // Mock methods for compatibility
  bool get isOnboardingComplete => true; // Always true for testing
  
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (_currentUser == null) return null;
    return {
      'user_id': _currentUser!.uid,
      'email': _currentUser!.email,
      'name': _currentUser!.displayName ?? '',
      'credits': 100, // Mock credits
    };
  }
  
  Future<int> getUserCredits() async {
    return 100; // Mock credits
  }
  
  Future<void> completeOnboarding() async {
    // Mock implementation
  }
}
