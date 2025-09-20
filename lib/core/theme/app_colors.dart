import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color royalPurple = Color(0xFF6A0DAD);
  static const Color electricBlue = Color(0xFF007BFF);
  static const Color neonGreen = Color(0xFF00FFB2);
  
  // Base Colors
  static const Color deepCharcoal = Color(0xFF121212);
  static const Color lightLavender = Color(0xFFE6E6FA);
  static const Color warmOrange = Color(0xFFFF7A00);
  static const Color brightRed = Color(0xFFFF3B3B);
  
  // Glassmorphism Colors
  static const Color glassLight = Color(0x0DFFFFFF); // rgba(255, 255, 255, 0.05)
  static const Color glassCard = Color(0x14FFFFFF); // rgba(255, 255, 255, 0.08)
  static const Color glassBorder = Color(0x26FFFFFF); // rgba(255, 255, 255, 0.15)
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF); // rgba(255, 255, 255, 0.7)
  static const Color textTertiary = Color(0x80FFFFFF); // rgba(255, 255, 255, 0.5)
  static const Color textDisabled = Color(0x4DFFFFFF); // rgba(255, 255, 255, 0.3)
  
  // Status Colors
  static const Color success = neonGreen;
  static const Color warning = warmOrange;
  static const Color error = brightRed;
  static const Color info = electricBlue;
  
  // Background Colors
  static const Color backgroundPrimary = deepCharcoal;
  static const Color backgroundSecondary = Color(0xFF1A1A1A);
  static const Color backgroundTertiary = Color(0xFF252525);
  
  // Card Colors
  static const Color cardBackground = glassCard;
  static const Color cardBorder = glassBorder;
  
  // Button Colors
  static const Color buttonPrimary = royalPurple;
  static const Color buttonSecondary = electricBlue;
  static const Color buttonAccent = neonGreen;
  static const Color buttonDisabled = Color(0x4DFFFFFF);
  
  // Input Colors
  static const Color inputBackground = Color(0x1AFFFFFF);
  static const Color inputBorder = Color(0x33FFFFFF);
  static const Color inputFocus = electricBlue;
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [royalPurple, electricBlue],
  );
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [electricBlue, neonGreen],
  );
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonGreen, warmOrange],
  );
  // Backwards-compatible gradients expected as Gradient
  static const LinearGradient purpleBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      royalPurple,
      electricBlue,
    ],
  );
  static const LinearGradient neonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      electricBlue,
      neonGreen,
    ],
  );
  static List<Color> backgroundGradient = [
    const Color(0xFF0F0F0F),
    deepCharcoal,
    const Color(0xFF1A1A1A),
  ];
  
  // Chart Colors
  static const List<Color> chartColors = [
    royalPurple,
    electricBlue,
    neonGreen,
    warmOrange,
    brightRed,
    lightLavender,
  ];
  
  // Neon Glow Colors
  static Color neonGlowPurple = royalPurple.withOpacity(0.5);
  static Color neonGlowBlue = electricBlue.withOpacity(0.5);
  static Color neonGlowGreen = neonGreen.withOpacity(0.5);
  // Backwards-compatible shadow aliases
  static const Color neonShadowPurple = royalPurple;
  static const Color neonShadowBlue = electricBlue;
  
  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.1);
  static Color shadowMedium = Colors.black.withOpacity(0.2);
  static Color shadowHeavy = Colors.black.withOpacity(0.3);
  
  // Test Status Colors
  static const Color testPending = warmOrange;
  static const Color testInProgress = electricBlue;
  static const Color testCompleted = neonGreen;
  static const Color testFailed = brightRed;
  
  // Credit System Colors
  static const Color creditsEarned = neonGreen;
  static const Color creditsSpent = warmOrange;
  static const Color creditsBonus = royalPurple;
  
  // Store Colors
  static const Color storePremium = royalPurple;
  static const Color storeDiscount = neonGreen;
  static const Color storeOutOfStock = Color(0xFF666666);
  static const Color storeFeatured = electricBlue;

  // Backwards-compatible semantic aliases used across app
  static const Color primary = royalPurple;
  static const Color surface = backgroundSecondary;
  static const Color secondaryText = textSecondary;
  static const Color mutedText = textTertiary;
  static const Color accent = neonGreen;
  static const Color glassSurface = glassCard;

  // Greyscale palette often referenced
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
}