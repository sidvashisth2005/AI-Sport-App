import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();
  
  SupabaseService._();
  
  SupabaseClient get client => Supabase.instance.client;
  
  // Auth methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  // Backwards-compatible wrappers (instance methods)
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return signUp(email: email, password: password, data: data);
  }
  
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return signIn(email: email, password: password);
  }

  // Static convenience wrappers for legacy static calls with distinct names
  static Future<AuthResponse> signInWithEmailStatic({
    required String email,
    required String password,
  }) {
    return SupabaseService.instance.signInWithEmail(email: email, password: password);
  }

  static Future<AuthResponse> signUpWithEmailStatic({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) {
    return SupabaseService.instance.signUpWithEmail(email: email, password: password, data: data);
  }
  
  Future<void> signOut() async {
    await client.auth.signOut();
  }
  
  Future<UserResponse> updateUser({
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.updateUser(
      UserAttributes(data: data),
    );
  }
  
  User? get currentUser => client.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
  
  // Database methods
  Future<List<Map<String, dynamic>>> select(
    String table, {
    String? select,
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    dynamic query = client.from(table).select(select ?? '*');
    
    if (filters != null) {
      filters.forEach((key, value) {
        query = query.eq(key, value);
      });
    }
    
    if (orderBy != null) {
      query = query.order(orderBy, ascending: ascending);
    }
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }
  
  Future<Map<String, dynamic>> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    final response = await client
        .from(table)
        .insert(data)
        .select()
        .single();
    return response;
  }
  
  Future<Map<String, dynamic>> update(
    String table,
    Map<String, dynamic> data, {
    required Map<String, dynamic> filters,
  }) async {
    dynamic query = client.from(table).update(data);
    
    filters.forEach((key, value) {
      query = query.eq(key, value);
    });
    
    final response = await query.select().single();
    return response;
  }
  
  Future<void> delete(
    String table, {
    required Map<String, dynamic> filters,
  }) async {
    dynamic query = client.from(table).delete();
    
    filters.forEach((key, value) {
      query = query.eq(key, value);
    });
    
    await query;
  }
  
  // File storage methods
  Future<String> uploadFile(
    String bucket,
    String path,
    Uint8List fileBytes, {
    String? contentType,
  }) async {
    await client.storage.from(bucket).uploadBinary(
      path,
      fileBytes,
      fileOptions: FileOptions(
        contentType: contentType,
      ),
    );
    
    return client.storage.from(bucket).getPublicUrl(path);
  }
  
  Future<void> deleteFile(String bucket, String path) async {
    await client.storage.from(bucket).remove([path]);
  }
  
  String getPublicUrl(String bucket, String path) {
    return client.storage.from(bucket).getPublicUrl(path);
  }
  
  // Real-time subscriptions
  RealtimeChannel subscribeToTable(
    String table,
    void Function(PostgresChangePayload) callback, {
    PostgresChangeEvent event = PostgresChangeEvent.all,
    String? schema,
  }) {
    final channel = client
        .channel('public:$table')
        .onPostgresChanges(
          event: event,
          schema: schema ?? 'public',
          table: table,
          callback: callback,
        )
        .subscribe();
    
    return channel;
  }
  
  // Test results methods
  Future<Map<String, dynamic>> saveTestResult({
    required String userId,
    required String testType,
    required Map<String, dynamic> results,
    required Map<String, dynamic> analysis,
  }) async {
    return await insert('test_results', {
      'user_id': userId,
      'test_type': testType,
      'results': results,
      'analysis': analysis,
      'completed_at': DateTime.now().toIso8601String(),
    });
  }
  
  Future<List<Map<String, dynamic>>> getUserTestResults(String userId) async {
    return await select(
      'test_results',
      filters: {'user_id': userId},
      orderBy: 'completed_at',
      ascending: false,
    );
  }
  
  // Credit points methods
  Future<void> addCredits({
    required String userId,
    required int amount,
    required String reason,
    String? referenceId,
  }) async {
    await insert('credit_transactions', {
      'user_id': userId,
      'amount': amount,
      'type': 'earned',
      'reason': reason,
      'reference_id': referenceId,
      'created_at': DateTime.now().toIso8601String(),
    });
    
    // Update user's total credits
    final currentCredits = await getUserCredits(userId);
    await update(
      'user_profiles',
      {'credits': currentCredits + amount},
      filters: {'user_id': userId},
    );
  }
  
  Future<void> deductCredits({
    required String userId,
    required int amount,
    required String reason,
    String? referenceId,
  }) async {
    final currentCredits = await getUserCredits(userId);
    if (currentCredits < amount) {
      throw Exception('Insufficient credits');
    }
    
    await insert('credit_transactions', {
      'user_id': userId,
      'amount': -amount,
      'type': 'spent',
      'reason': reason,
      'reference_id': referenceId,
      'created_at': DateTime.now().toIso8601String(),
    });
    
    await update(
      'user_profiles',
      {'credits': currentCredits - amount},
      filters: {'user_id': userId},
    );
  }
  
  Future<int> getUserCredits(String userId) async {
    final profile = await select(
      'user_profiles',
      select: 'credits',
      filters: {'user_id': userId},
    );
    
    if (profile.isEmpty) return 0;
    return profile.first['credits'] ?? 0;
  }
  
  // Mentor booking methods
  Future<List<Map<String, dynamic>>> getMentors() async {
    return await select(
      'mentors',
      select: '*, mentor_specializations(*)',
      orderBy: 'rating',
      ascending: false,
    );
  }
  
  Future<Map<String, dynamic>> bookMentor({
    required String userId,
    required String mentorId,
    required DateTime scheduledAt,
    required String sessionType,
    required int credits,
  }) async {
    // Deduct credits first
    await deductCredits(
      userId: userId,
      amount: credits,
      reason: 'Mentor booking',
      referenceId: mentorId,
    );
    
    return await insert('mentor_bookings', {
      'user_id': userId,
      'mentor_id': mentorId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'session_type': sessionType,
      'credits_used': credits,
      'status': 'confirmed',
      'created_at': DateTime.now().toIso8601String(),
    });
  }
  
  // Store methods
  Future<List<Map<String, dynamic>>> getStoreProducts({
    String? category,
    String? search,
  }) async {
    dynamic query = client.from('store_products').select('*');
    
    if (category != null) {
      query = query.eq('category', category);
    }
    
    if (search != null) {
      query = query.textSearch('name', search);
    }
    
    query = query.eq('is_active', true);
    query = query.order('featured', ascending: false);
    query = query.order('created_at', ascending: false);
    
    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }
  
  Future<Map<String, dynamic>> createOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String paymentMethod,
    Map<String, dynamic>? shippingAddress,
  }) async {
    return await insert('orders', {
      'user_id': userId,
      'items': items,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'shipping_address': shippingAddress,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    });
  }
  
  // Leaderboard methods
  Future<List<Map<String, dynamic>>> getLeaderboard({
    String? testType,
    String period = 'all_time',
    int limit = 50,
  }) async {
    dynamic query = client.from('leaderboard_view').select('*');
    
    if (testType != null) {
      query = query.eq('test_type', testType);
    }
    
    if (period != 'all_time') {
      final date = _getDateForPeriod(period);
      query = query.gte('completed_at', date.toIso8601String());
    }
    
    query = query.order('score', ascending: false);
    query = query.limit(limit);
    
    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }
  
  DateTime _getDateForPeriod(String period) {
    final now = DateTime.now();
    switch (period) {
      case 'today':
        return DateTime(now.year, now.month, now.day);
      case 'week':
        return now.subtract(const Duration(days: 7));
      case 'month':
        return DateTime(now.year, now.month, 1);
      default:
        return DateTime(2000);
    }
  }
  
  // Community methods
  Future<List<Map<String, dynamic>>> getCommunityPosts({
    int limit = 20,
    int offset = 0,
  }) async {
    return await select(
      'community_posts',
      select: '*, user_profiles(name, avatar_url), post_likes(count)',
      orderBy: 'created_at',
      ascending: false,
      limit: limit,
    );
  }
  
  Future<Map<String, dynamic>> createPost({
    required String userId,
    required String content,
    List<String>? images,
    String? videoUrl,
  }) async {
    return await insert('community_posts', {
      'user_id': userId,
      'content': content,
      'images': images,
      'video_url': videoUrl,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}