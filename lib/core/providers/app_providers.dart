import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
// ignore: unused_import
// Removed unnecessary state_notifier import; flutter_riverpod exports needed types
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firebase_auth_test_service.dart';

// Auth Providers
final authServiceProvider = Provider<FirebaseAuthTestService>((ref) {
  return FirebaseAuthTestService.instance;
});

final currentUserProvider = Provider((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.isAuthenticated;
});

final isOnboardingCompleteProvider = Provider<bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.isOnboardingComplete;
});

// Firebase Firestore Provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// User Profile Provider
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  if (!authService.isAuthenticated) return null;
  
  return await authService.getUserProfile();
});

// User Credits Provider
final userCreditsProvider = FutureProvider<int>((ref) async {
  final authService = ref.watch(authServiceProvider);
  if (!authService.isAuthenticated) return 0;
  
  return await authService.getUserCredits();
});

// Test Results Provider
final userTestResultsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final firestore = ref.watch(firestoreProvider);
  
  if (!authService.isAuthenticated) return [];
  
  try {
    final query = await firestore
        .collection('test_results')
        .where('user_id', isEqualTo: authService.currentUser!.uid)
        .orderBy('created_at', descending: true)
        .get();
    
    return query.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  } catch (e) {
    return [];
  }
});

// Leaderboard Provider
final leaderboardProvider = FutureProvider.family<List<Map<String, dynamic>>, Map<String, dynamic>>((ref, params) async {
  final firestore = ref.watch(firestoreProvider);
  
  try {
    final query = await firestore
        .collection('test_results')
        .orderBy('score', descending: true)
        .limit(params['limit'] ?? 50)
        .get();
    
    return query.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  } catch (e) {
    return [];
  }
});

// Mentors Provider
final mentorsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final firestore = ref.watch(firestoreProvider);
  
  try {
    final query = await firestore.collection('mentors').get();
    return query.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  } catch (e) {
    return [];
  }
});

// Store Products Provider
final storeProductsProvider = FutureProvider.family<List<Map<String, dynamic>>, Map<String, String?>>((ref, params) async {
  final firestore = ref.watch(firestoreProvider);
  
  try {
    Query query = firestore.collection('products');
    
    if (params['category'] != null) {
      query = query.where('category', isEqualTo: params['category']);
    }
    
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>,
    }).toList();
  } catch (e) {
    return [];
  }
});

// Community Posts Provider
final communityPostsProvider = FutureProvider.family<List<Map<String, dynamic>>, Map<String, int>>((ref, params) async {
  final firestore = ref.watch(firestoreProvider);
  
  try {
    final query = await firestore
        .collection('community_posts')
        .orderBy('created_at', descending: true)
        .limit(params['limit'] ?? 20)
        .get();
    
    return query.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  } catch (e) {
    return [];
  }
});

// Connectivity Provider
final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    return results.isNotEmpty ? results.first : ConnectivityResult.none;
  });
});

final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (result) => result != ConnectivityResult.none,
    loading: () => true, // Assume online while loading
    error: (_, __) => false,
  );
});

// State Management for UI
class LoadingState extends StateNotifier<bool> {
  LoadingState() : super(false);
  
  void setLoading(bool loading) {
    state = loading;
  }
}

final loadingProvider = StateNotifierProvider<LoadingState, bool>((ref) {
  return LoadingState();
});

class ErrorState extends StateNotifier<String?> {
  ErrorState() : super(null);
  
  void setError(String? error) {
    state = error;
  }
  
  void clearError() {
    state = null;
  }
}

final errorProvider = StateNotifierProvider<ErrorState, String?>((ref) {
  return ErrorState();
});

// Selected Test Provider
class SelectedTestState extends StateNotifier<String?> {
  SelectedTestState() : super(null);
  
  void selectTest(String testId) {
    state = testId;
  }
  
  void clearSelection() {
    state = null;
  }
}

final selectedTestProvider = StateNotifierProvider<SelectedTestState, String?>((ref) {
  return SelectedTestState();
});

// Bottom Navigation Provider
class BottomNavState extends StateNotifier<int> {
  BottomNavState() : super(0);
  
  void setIndex(int index) {
    state = index;
  }
}

final bottomNavProvider = StateNotifierProvider<BottomNavState, int>((ref) {
  return BottomNavState();
});

// Search Provider
class SearchState extends StateNotifier<String> {
  SearchState() : super('');
  
  void updateSearch(String query) {
    state = query;
  }
  
  void clearSearch() {
    state = '';
  }
}

final searchProvider = StateNotifierProvider<SearchState, String>((ref) {
  return SearchState();
});

// Filter Provider
class FilterState extends StateNotifier<Map<String, dynamic>> {
  FilterState() : super({});
  
  void updateFilter(String key, dynamic value) {
    state = {...state, key: value};
  }
  
  void removeFilter(String key) {
    final newState = Map<String, dynamic>.from(state);
    newState.remove(key);
    state = newState;
  }
  
  void clearFilters() {
    state = {};
  }
}

final filterProvider = StateNotifierProvider<FilterState, Map<String, dynamic>>((ref) {
  return FilterState();
});

// Theme Provider
class ThemeState extends StateNotifier<bool> {
  ThemeState() : super(true); // Default to dark mode
  
  void toggleTheme() {
    state = !state;
  }
  
  void setDarkMode(bool isDark) {
    state = isDark;
  }
}

final themeProvider = StateNotifierProvider<ThemeState, bool>((ref) {
  return ThemeState();
});

// Notifications Provider
class NotificationState extends StateNotifier<List<Map<String, dynamic>>> {
  NotificationState() : super([]);
  
  void addNotification(Map<String, dynamic> notification) {
    state = [...state, notification];
  }
  
  void removeNotification(String id) {
    state = state.where((n) => n['id'] != id).toList();
  }
  
  void clearNotifications() {
    state = [];
  }
  
  void markAsRead(String id) {
    state = state.map((n) {
      if (n['id'] == id) {
        return {...n, 'read': true};
      }
      return n;
    }).toList();
  }
}

final notificationProvider = StateNotifierProvider<NotificationState, List<Map<String, dynamic>>>((ref) {
  return NotificationState();
});

// Test Recording State
class TestRecordingState extends StateNotifier<Map<String, dynamic>> {
  TestRecordingState() : super({
    'isRecording': false,
    'duration': 0,
    'testType': null,
    'data': {},
  });
  
  void startRecording(String testType) {
    state = {
      ...state,
      'isRecording': true,
      'testType': testType,
      'duration': 0,
      'data': {},
    };
  }
  
  void stopRecording() {
    state = {
      ...state,
      'isRecording': false,
    };
  }
  
  void updateDuration(int duration) {
    state = {
      ...state,
      'duration': duration,
    };
  }
  
  void updateData(Map<String, dynamic> data) {
    state = {
      ...state,
      'data': {...state['data'], ...data},
    };
  }
  
  void resetRecording() {
    state = {
      'isRecording': false,
      'duration': 0,
      'testType': null,
      'data': {},
    };
  }
}

final testRecordingProvider = StateNotifierProvider<TestRecordingState, Map<String, dynamic>>((ref) {
  return TestRecordingState();
});

// Cart Provider for Store
class CartState extends StateNotifier<List<Map<String, dynamic>>> {
  CartState() : super([]);
  
  void addItem(Map<String, dynamic> product, int quantity) {
    final existingIndex = state.indexWhere((item) => item['product']['id'] == product['id']);
    
    if (existingIndex != -1) {
      // Update quantity
      final updatedItems = [...state];
      updatedItems[existingIndex] = {
        ...updatedItems[existingIndex],
        'quantity': updatedItems[existingIndex]['quantity'] + quantity,
      };
      state = updatedItems;
    } else {
      // Add new item
      state = [...state, {'product': product, 'quantity': quantity}];
    }
  }
  
  void removeItem(String productId) {
    state = state.where((item) => item['product']['id'] != productId).toList();
  }
  
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    
    state = state.map((item) {
      if (item['product']['id'] == productId) {
        return {...item, 'quantity': quantity};
      }
      return item;
    }).toList();
  }
  
  void clearCart() {
    state = [];
  }
  
  double get totalAmount {
    return state.fold(0.0, (total, item) {
      final price = (item['product']['price'] ?? 0.0) as double;
      final quantity = item['quantity'] as int;
      return total + (price * quantity);
    });
  }
  
  int get itemCount {
    return state.fold(0, (total, item) => total + (item['quantity'] as int));
  }
}

final cartProvider = StateNotifierProvider<CartState, List<Map<String, dynamic>>>((ref) {
  return CartState();
});

// Wishlist Provider
class WishlistState extends StateNotifier<List<Map<String, dynamic>>> {
  WishlistState() : super([]);
  
  void addItem(Map<String, dynamic> product) {
    if (!state.any((item) => item['id'] == product['id'])) {
      state = [...state, product];
    }
  }
  
  void removeItem(String productId) {
    state = state.where((item) => item['id'] != productId).toList();
  }
  
  void toggleItem(Map<String, dynamic> product) {
    if (state.any((item) => item['id'] == product['id'])) {
      removeItem(product['id']);
    } else {
      addItem(product);
    }
  }
  
  bool isInWishlist(String productId) {
    return state.any((item) => item['id'] == productId);
  }
}

final wishlistProvider = StateNotifierProvider<WishlistState, List<Map<String, dynamic>>>((ref) {
  return WishlistState();
});