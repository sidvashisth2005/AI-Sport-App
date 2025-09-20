import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

class ErrorHandler {
  static void handleFlutterError(FlutterErrorDetails details) {
    if (kDebugMode) {
      // In debug mode, print the error details
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production, log to crash reporting service
      _logErrorToService(details.exception, details.stack);
    }
  }
  
  static void handleError(dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('Error: $error');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    } else {
      _logErrorToService(error, stackTrace);
    }
  }
  
  static void _logErrorToService(dynamic error, StackTrace? stackTrace) {
    // TODO: Implement crash reporting service (Firebase Crashlytics, Sentry, etc.)
    debugPrint('Production Error: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
  }
  
  static String getErrorMessage(dynamic error) {
    if (error is String) {
      return error;
    }
    
    if (error is PlatformException) {
      return error.message ?? 'Platform error occurred';
    }
    
    if (error is FormatException) {
      return 'Invalid data format';
    }
    
    if (error is ArgumentError) {
      return 'Invalid argument provided';
    }
    
    if (error is StateError) {
      return 'Invalid state';
    }
    
    if (error is RangeError) {
      return 'Value out of range';
    }
    
    if (error is TypeError) {
      return 'Type error occurred';
    }
    
    if (error is NoSuchMethodError) {
      return 'Method not found';
    }
    
    if (error is UnimplementedError) {
      return 'Feature not implemented';
    }
    
    if (error is UnsupportedError) {
      return 'Operation not supported';
    }
    
    if (error is TimeoutException) {
      return 'Request timed out';
    }
    
    if (error is SocketException) {
      return 'Network connection error';
    }
    
    if (error is HttpException) {
      return 'HTTP error occurred';
    }
    
    if (error is CertificateException) {
      return 'Certificate error';
    }
    
    if (error is HandshakeException) {
      return 'SSL handshake error';
    }
    
    // Supabase specific errors
    if (error.toString().contains('Invalid login credentials')) {
      return 'Invalid email or password';
    }
    
    if (error.toString().contains('Email not confirmed')) {
      return 'Please verify your email address';
    }
    
    if (error.toString().contains('User already registered')) {
      return 'This email is already registered';
    }
    
    if (error.toString().contains('Weak password')) {
      return 'Password is too weak';
    }
    
    if (error.toString().contains('Invalid email')) {
      return 'Please enter a valid email address';
    }
    
    if (error.toString().contains('Network error')) {
      return 'Network connection error';
    }
    
    if (error.toString().contains('Server error')) {
      return 'Server error. Please try again later';
    }
    
    if (error.toString().contains('Unauthorized')) {
      return 'You are not authorized to perform this action';
    }
    
    if (error.toString().contains('Forbidden')) {
      return 'Access forbidden';
    }
    
    if (error.toString().contains('Not found')) {
      return 'Resource not found';
    }
    
    if (error.toString().contains('Conflict')) {
      return 'Data conflict occurred';
    }
    
    if (error.toString().contains('Too many requests')) {
      return 'Too many requests. Please try again later';
    }
    
    if (error.toString().contains('Service unavailable')) {
      return 'Service temporarily unavailable';
    }
    
    // Default error message
    return 'An unexpected error occurred. Please try again.';
  }
  
  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final message = getErrorMessage(error);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFF3B3B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
  
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00FFB2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  static void showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_outlined,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFF7A00),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF007BFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  static Future<bool?> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onAction,
    bool showCancel = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0x26FFFFFF),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFFFF3B3B),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Color(0xB3FFFFFF),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          if (showCancel)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onAction?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B3B),
              foregroundColor: Colors.white,
            ),
            child: Text(actionText ?? 'OK'),
          ),
        ],
      ),
    );
  }
}

// Custom exceptions
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  
  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  
  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
  
  @override
  String toString() => message;
}

class TestException implements Exception {
  final String message;
  TestException(this.message);
  
  @override
  String toString() => message;
}

class StoreException implements Exception {
  final String message;
  StoreException(this.message);
  
  @override
  String toString() => message;
}

class CreditException implements Exception {
  final String message;
  CreditException(this.message);
  
  @override
  String toString() => message;
}