import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../services/firebase_auth_test_service.dart';
import '../../features/store/data/models/product_model.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/test/presentation/screens/test_detail_screen.dart';
import '../../features/test/presentation/screens/calibration_screen.dart';
import '../../features/test/presentation/screens/recording_screen.dart';
import '../../features/test/presentation/screens/test_completion_screen.dart';
import '../../features/results/presentation/screens/results_screen.dart';
import '../../features/results/presentation/screens/combined_results_screen.dart';
import '../../features/test_history/presentation/screens/test_history_screen.dart';
import '../../features/leaderboard/presentation/screens/leaderboard_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/profile_edit_screen.dart';
import '../../features/mentors/presentation/screens/mentor_screen_with_tabs.dart';
import '../../features/store/presentation/screens/store_screen.dart';
import '../../features/store/presentation/screens/product_detail_screen.dart';
import '../../features/store/presentation/screens/nearby_stores_screen.dart';
import '../../features/personalized_solution/presentation/screens/personalized_solution_screen.dart';
import '../../features/community/presentation/screens/community_screen.dart';
import '../../features/achievements/presentation/screens/achievements_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/credits/presentation/screens/credits_screen.dart';
import '../../features/help/presentation/screens/help_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../shared/presentation/widgets/main_layout.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authService = FirebaseAuthTestService.instance;
  
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authService.isAuthenticated;
      final isOnboardingComplete = authService.isOnboardingComplete;
      final location = state.uri.toString();
      
      // Handle splash screen
      if (location == '/splash') {
        return null; // Let splash screen decide where to go
      }
      
      // If not authenticated, redirect to auth
      if (!isAuthenticated) {
        if (location.startsWith('/auth')) {
          return null; // Already on auth screen
        }
        return '/auth';
      }
      
      // If authenticated but onboarding not complete, redirect to onboarding
      if (isAuthenticated && !isOnboardingComplete) {
        if (location == '/onboarding') {
          return null; // Already on onboarding
        }
        return '/onboarding';
      }
      
      // If on auth or onboarding but already authenticated and onboarded, go to home
      if ((location.startsWith('/auth') || location == '/onboarding') && 
          isAuthenticated && isOnboardingComplete) {
        return '/home';
      }
      
      return null; // No redirect needed
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Authentication
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      
      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Main App Shell
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          // Home
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          
          // Test History
          GoRoute(
            path: '/history',
            name: 'history',
            builder: (context, state) => const TestHistoryScreen(),
          ),
          
          // Leaderboard
          GoRoute(
            path: '/leaderboard',
            name: 'leaderboard',
            builder: (context, state) => const LeaderboardScreen(),
          ),
          
          // Profile
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: '/edit',
                name: 'profile-edit',
                builder: (context, state) => const ProfileEditScreen(),
              ),
            ],
          ),
          
          // Mentors
          GoRoute(
            path: '/mentors',
            name: 'mentors',
            builder: (context, state) => const MentorScreenWithTabs(),
          ),
          
          // Store
          GoRoute(
            path: '/store',
            name: 'store',
            builder: (context, state) => const StoreScreen(),
            routes: [
              GoRoute(
                path: '/product/:id',
                name: 'product-detail',
                builder: (context, state) {
                  final productId = state.pathParameters['id']!;
                  return ProductDetailScreen(productId: productId);
                },
              ),
              GoRoute(
                path: '/nearby',
                name: 'nearby-stores',
                builder: (context, state) => NearbyStoresScreen(
                  product: Product(
                    id: 'default',
                    name: 'Default Product',
                    description: 'Default description',
                    price: 0.0,
                    creditPrice: 0,
                    imageUrl: '',
                    category: 'general',
                    rating: 0.0,
                    reviewCount: 0,
                  ),
                ),
              ),
            ],
          ),
          
          // Community
          GoRoute(
            path: '/community',
            name: 'community',
            builder: (context, state) => const CommunityScreen(),
          ),
          
          // Achievements
          GoRoute(
            path: '/achievements',
            name: 'achievements',
            builder: (context, state) => const AchievementsScreen(),
          ),
          
          // Analytics
          GoRoute(
            path: '/analytics',
            name: 'analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
          
          // Credits
          GoRoute(
            path: '/credits',
            name: 'credits',
            builder: (context, state) => const CreditsScreen(),
          ),
          
          // Help
          GoRoute(
            path: '/help',
            name: 'help',
            builder: (context, state) => const HelpScreen(),
          ),
          
          // Settings
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      
      // Test Flow (Full Screen)
      GoRoute(
        path: '/test/:testId',
        name: 'test-detail',
        builder: (context, state) {
          final testId = state.pathParameters['testId']!;
          return TestDetailScreen(testId: testId);
        },
        routes: [
          GoRoute(
            path: '/calibration',
            name: 'calibration',
            builder: (context, state) {
              final testId = state.pathParameters['testId']!;
              return CalibrationScreen(testId: testId);
            },
          ),
          GoRoute(
            path: '/recording',
            name: 'recording',
            builder: (context, state) {
              final testId = state.pathParameters['testId']!;
              return RecordingScreen(testId: testId);
            },
          ),
          GoRoute(
            path: '/completion',
            name: 'completion',
            builder: (context, state) {
              final testId = state.pathParameters['testId']!;
              final resultId = state.uri.queryParameters['resultId'];
              return TestCompletionScreen(
                testId: testId,
                resultId: resultId,
              );
            },
          ),
        ],
      ),
      
      // Results (Full Screen)
      GoRoute(
        path: '/results/:resultId',
        name: 'results',
        builder: (context, state) {
          final resultId = state.pathParameters['resultId']!;
          return ResultsScreen(resultId: resultId);
        },
      ),
      
      // Combined Results (Full Screen)
      GoRoute(
        path: '/combined-results',
        name: 'combined-results',
        builder: (context, state) {
          final resultIds = state.uri.queryParameters['ids']?.split(',') ?? [];
          return CombinedResultsScreen(resultIds: resultIds);
        },
      ),
      
      // 3D Personalized Solution (Full Screen)
      GoRoute(
        path: '/personalized-solution/:resultId',
        name: 'personalized-solution',
        builder: (context, state) {
          final resultId = state.pathParameters['resultId']!;
          return PersonalizedSolutionScreen(
            testResult: {
              'resultId': resultId,
              'testType': 'general',
              'score': 70,
            },
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFFF3B3B),
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Router helpers
extension GoRouterExtension on GoRouter {
  String get location {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}

// Navigation helpers
class AppNavigation {
  static final GoRouter _router = GoRouter.of(NavigatorService.navigatorKey.currentContext!);
  
  // Test flow navigation
  static void goToTestDetail(String testId) {
    _router.pushNamed('test-detail', pathParameters: {'testId': testId});
  }
  
  static void goToCalibration(String testId) {
    _router.pushNamed('calibration', pathParameters: {'testId': testId});
  }
  
  static void goToRecording(String testId) {
    _router.pushNamed('recording', pathParameters: {'testId': testId});
  }
  
  static void goToTestCompletion(String testId, {String? resultId}) {
    _router.pushNamed(
      'completion',
      pathParameters: {'testId': testId},
      queryParameters: resultId != null ? {'resultId': resultId} : {},
    );
  }
  
  static void goToResults(String resultId) {
    _router.pushNamed('results', pathParameters: {'resultId': resultId});
  }
  
  static void goToCombinedResults(List<String> resultIds) {
    _router.pushNamed(
      'combined-results',
      queryParameters: {'ids': resultIds.join(',')},
    );
  }
  
  static void goToPersonalizedSolution(String resultId) {
    _router.pushNamed(
      'personalized-solution',
      pathParameters: {'resultId': resultId},
    );
  }
  
  // Store navigation
  static void goToProductDetail(String productId) {
    _router.pushNamed('product-detail', pathParameters: {'id': productId});
  }
  
  static void goToNearbyStores() {
    _router.pushNamed('nearby-stores');
  }
  
  // Profile navigation
  static void goToProfileEdit() {
    _router.pushNamed('profile-edit');
  }
  
  // Main navigation
  static void goToHome() {
    _router.go('/home');
  }
  
  static void goToHistory() {
    _router.go('/history');
  }
  
  static void goToLeaderboard() {
    _router.go('/leaderboard');
  }
  
  static void goToProfile() {
    _router.go('/profile');
  }
  
  static void goToMentors() {
    _router.go('/mentors');
  }
  
  static void goToStore() {
    _router.go('/store');
  }
  
  static void goToCommunity() {
    _router.go('/community');
  }
  
  static void goToAchievements() {
    _router.go('/achievements');
  }
  
  static void goToAnalytics() {
    _router.go('/analytics');
  }
  
  static void goToCredits() {
    _router.go('/credits');
  }
  
  static void goToHelp() {
    _router.go('/help');
  }
  
  static void goToSettings() {
    _router.go('/settings');
  }
}

// Navigator service for global navigation
class NavigatorService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static NavigatorState? get navigator => navigatorKey.currentState;
  static BuildContext? get context => navigatorKey.currentContext;
}