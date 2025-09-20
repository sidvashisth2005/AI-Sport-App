import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class FirebaseAuthService extends ChangeNotifier {
  static FirebaseAuthService? _instance;
  static FirebaseAuthService get instance => _instance ??= FirebaseAuthService._();
  
  FirebaseAuthService._() {
    _init();
  }
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _currentUser;
  bool _isLoading = false;
  bool _isOnboardingComplete = false;
  String? _error;
  
  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get isOnboardingComplete => _isOnboardingComplete;
  String? get error => _error;
  
  void _init() {
    _currentUser = _auth.currentUser;
    _loadOnboardingStatus();
    
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      if (user != null) {
        _loadUserProfile();
      } else {
        _isOnboardingComplete = false;
        _clearLocalData();
      }
      notifyListeners();
    });
  }
  
  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isOnboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  }
  
  Future<void> _saveOnboardingStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', status);
    _isOnboardingComplete = status;
  }
  
  Future<void> _clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  Future<void> _loadUserProfile() async {
    if (_currentUser == null) return;
    
    try {
      final doc = await _firestore
          .collection('user_profiles')
          .doc(_currentUser!.uid)
          .get();
      
      if (!doc.exists) {
        // Create initial profile
        await _createUserProfile();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user profile: $e');
      }
    }
  }
  
  Future<void> _createUserProfile() async {
    if (_currentUser == null) return;
    
    try {
      await _firestore.collection('user_profiles').doc(_currentUser!.uid).set({
        'user_id': _currentUser!.uid,
        'email': _currentUser!.email,
        'name': _currentUser!.displayName ?? '',
        'avatar_url': _currentUser!.photoURL,
        'credits': AppConfig.testCompletionCredits, // Welcome credits
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
      
      // Add welcome credits transaction
      await _addCredits(
        userId: _currentUser!.uid,
        amount: AppConfig.testCompletionCredits,
        reason: 'Welcome bonus',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user profile: $e');
      }
    }
  }
  
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
    String? dateOfBirth,
    String? gender,
    String? location,
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
        
        // Create user profile
        await _firestore.collection('user_profiles').doc(credential.user!.uid).set({
          'user_id': credential.user!.uid,
          'email': email,
          'name': name,
          'phone_number': phoneNumber,
          'date_of_birth': dateOfBirth,
          'gender': gender,
          'location': location,
          'credits': AppConfig.testCompletionCredits,
          'created_at': FieldValue.serverTimestamp(),
          'updated_at': FieldValue.serverTimestamp(),
        });
        
        // Add welcome credits
        await _addCredits(
          userId: credential.user!.uid,
          amount: AppConfig.testCompletionCredits,
          reason: 'Welcome bonus',
        );
        
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
        await _loadUserProfile();
        
        // Award daily login credits
        await _awardDailyLoginCredits();
        
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
  
  Future<void> _awardDailyLoginCredits() async {
    if (_currentUser == null) return;
    
    try {
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      // Check if user already received daily credits today
      final query = await _firestore
          .collection('credit_transactions')
          .where('user_id', isEqualTo: _currentUser!.uid)
          .where('reason', isEqualTo: 'Daily login')
          .get();
      
      final todayTransaction = query.docs.where((doc) {
        final data = doc.data();
        final createdAt = (data['created_at'] as Timestamp).toDate();
        final createdStr = '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
        return createdStr == todayStr;
      }).toList();
      
      if (todayTransaction.isEmpty) {
        await _addCredits(
          userId: _currentUser!.uid,
          amount: AppConfig.dailyLoginCredits,
          reason: 'Daily login',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error awarding daily login credits: $e');
      }
    }
  }
  
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _auth.signOut();
      _currentUser = null;
      _isOnboardingComplete = false;
      await _clearLocalData();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> updateProfile({
    String? name,
    String? phoneNumber,
    String? dateOfBirth,
    String? gender,
    String? location,
    String? avatarUrl,
    Map<String, dynamic>? preferences,
  }) async {
    if (_currentUser == null) return false;
    
    try {
      _setLoading(true);
      _setError(null);
      
      final updateData = <String, dynamic>{};
      
      if (name != null) updateData['name'] = name;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;
      if (dateOfBirth != null) updateData['date_of_birth'] = dateOfBirth;
      if (gender != null) updateData['gender'] = gender;
      if (location != null) updateData['location'] = location;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;
      if (preferences != null) updateData['preferences'] = preferences;
      
      if (updateData.isNotEmpty) {
        updateData['updated_at'] = FieldValue.serverTimestamp();
        
        await _firestore
            .collection('user_profiles')
            .doc(_currentUser!.uid)
            .update(updateData);
      }
      
      // Update auth display name if needed
      if (name != null) {
        await _currentUser!.updateDisplayName(name);
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);
      
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) return false;
    
    try {
      _setLoading(true);
      _setError(null);
      
      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: _currentUser!.email!,
        password: currentPassword,
      );
      
      await _currentUser!.reauthenticateWithCredential(credential);
      
      // Update password
      await _currentUser!.updatePassword(newPassword);
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (_currentUser == null) return null;
    
    try {
      final doc = await _firestore
          .collection('user_profiles')
          .doc(_currentUser!.uid)
          .get();
      
      return doc.exists ? doc.data() : null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user profile: $e');
      }
      return null;
    }
  }
  
  Future<int> getUserCredits() async {
    if (_currentUser == null) return 0;
    
    try {
      final doc = await _firestore
          .collection('user_profiles')
          .doc(_currentUser!.uid)
          .get();
      
      if (doc.exists) {
        final data = doc.data()!;
        return data['credits'] ?? 0;
      }
      return 0;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user credits: $e');
      }
      return 0;
    }
  }
  
  Future<void> _addCredits({
    required String userId,
    required int amount,
    required String reason,
  }) async {
    try {
      // Add credit transaction
      await _firestore.collection('credit_transactions').add({
        'user_id': userId,
        'amount': amount,
        'reason': reason,
        'created_at': FieldValue.serverTimestamp(),
      });
      
      // Update user credits
      await _firestore.collection('user_profiles').doc(userId).update({
        'credits': FieldValue.increment(amount),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding credits: $e');
      }
    }
  }
  
  Future<void> completeOnboarding() async {
    await _saveOnboardingStatus(true);
    notifyListeners();
  }
  
  Future<void> deleteAccount() async {
    if (_currentUser == null) return;
    
    try {
      _setLoading(true);
      
      // Delete user profile and related data
      await _firestore.collection('user_profiles').doc(_currentUser!.uid).delete();
      
      // Delete user account
      await _currentUser!.delete();
      
      // Sign out
      await signOut();
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
}
