import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'supabase_service.dart';
import '../config/app_config.dart';

class AuthService extends ChangeNotifier {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();
  
  AuthService._() {
    _init();
  }
  
  final SupabaseService _supabase = SupabaseService.instance;
  
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
    _currentUser = _supabase.currentUser;
    _loadOnboardingStatus();
    
    // Listen to auth state changes
    _supabase.authStateChanges.listen((data) {
      final event = data.event;
      final user = data.session?.user;
      
      if (event == AuthChangeEvent.signedIn) {
        _currentUser = user;
        _loadUserProfile();
      } else if (event == AuthChangeEvent.signedOut) {
        _currentUser = null;
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
      final profiles = await _supabase.select(
        'user_profiles',
        filters: {'user_id': _currentUser!.id},
      );
      
      if (profiles.isEmpty) {
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
    
    await _supabase.insert('user_profiles', {
      'user_id': _currentUser!.id,
      'email': _currentUser!.email,
      'name': _currentUser!.userMetadata?['name'] ?? '',
      'avatar_url': _currentUser!.userMetadata?['avatar_url'],
      'credits': AppConfig.testCompletionCredits, // Welcome credits
      'created_at': DateTime.now().toIso8601String(),
    });
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
      
      final response = await _supabase.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'phone_number': phoneNumber,
          'date_of_birth': dateOfBirth,
          'gender': gender,
          'location': location,
        },
      );
      
      if (response.user != null) {
        _currentUser = response.user;
        await _createUserProfile();
        
        // Award welcome credits
        await _supabase.addCredits(
          userId: _currentUser!.id,
          amount: AppConfig.testCompletionCredits,
          reason: 'Welcome bonus',
        );
        
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
      
      final response = await _supabase.signIn(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        _currentUser = response.user;
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
      final transactions = await _supabase.select(
        'credit_transactions',
        filters: {
          'user_id': _currentUser!.id,
          'reason': 'Daily login',
        },
      );
      
      final todayTransaction = transactions.where((t) {
        final createdAt = DateTime.parse(t['created_at']);
        final createdStr = '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
        return createdStr == todayStr;
      }).toList();
      
      if (todayTransaction.isEmpty) {
        await _supabase.addCredits(
          userId: _currentUser!.id,
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
      await _supabase.signOut();
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
        updateData['updated_at'] = DateTime.now().toIso8601String();
        
        await _supabase.update(
          'user_profiles',
          updateData,
          filters: {'user_id': _currentUser!.id},
        );
      }
      
      // Update auth metadata if needed
      final authUpdateData = <String, dynamic>{};
      if (name != null) authUpdateData['name'] = name;
      if (avatarUrl != null) authUpdateData['avatar_url'] = avatarUrl;
      
      if (authUpdateData.isNotEmpty) {
        await _supabase.updateUser(data: authUpdateData);
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
      
      await _supabase.client.auth.resetPasswordForEmail(email);
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
      
      // First verify current password by signing in
      await _supabase.signIn(
        email: _currentUser!.email!,
        password: currentPassword,
      );
      
      // Update password
      await _supabase.updateUser(data: {'password': newPassword});
      
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
      final profiles = await _supabase.select(
        'user_profiles',
        filters: {'user_id': _currentUser!.id},
      );
      
      return profiles.isNotEmpty ? profiles.first : null;
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
      return await _supabase.getUserCredits(_currentUser!.id);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user credits: $e');
      }
      return 0;
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
      await _supabase.delete(
        'user_profiles',
        filters: {'user_id': _currentUser!.id},
      );
      
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