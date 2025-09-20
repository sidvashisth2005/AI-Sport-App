class AppConfig {
  // Supabase Configuration
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';
  
  // App Configuration
  static const String appName = 'Sports Talent Assessment';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@sportsassessment.in';
  
  // API Endpoints
  static const String baseApiUrl = 'https://api.sportsassessment.in';
  static const String aiAnalysisEndpoint = '/analysis';
  static const String mentorBookingEndpoint = '/mentors';
  static const String storeEndpoint = '/store';
  
  // App Features
  static const bool enableOfflineMode = true;
  static const bool enableHapticFeedback = true;
  static const bool enablePushNotifications = true;
  static const bool enable3DModels = true;
  
  // Credit System
  static const int testCompletionCredits = 10;
  static const int dailyLoginCredits = 5;
  static const int achievementCredits = 25;
  static const int referralCredits = 50;
  
  // Test Configuration
  static const int maxTestDuration = 300; // 5 minutes
  static const int calibrationDuration = 30; // 30 seconds
  static const int warmupDuration = 60; // 1 minute
  
  // Store Configuration
  static const double freeShippingThreshold = 500.0;
  static const String defaultCurrency = 'INR';
  static const String razorpayKeyId = 'your-razorpay-key-here';
  
  // 3D Model Configuration
  static const String threeDModelBaseUrl = 'https://models.sportsassessment.in';
  static const int personalizedSolutionTimer = 300; // 5 minutes
  
  // Environment
  static const bool isProduction = false;
  static const bool enableDebugLogs = true;
}