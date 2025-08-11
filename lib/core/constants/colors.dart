import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const primary = Color(0xFF2563EB);
  static const primaryLight = Color(0xFF3B82F6);
  static const primaryDark = Color(0xFF1D4ED8);
  static const primaryContainer = Color(0xFFDBEAFE);
  
  // Secondary Colors
  static const secondary = Color(0xFF10B981);
  static const secondaryLight = Color(0xFF34D399);
  static const secondaryContainer = Color(0xFFD1FAE5);
  
  // Background Colors
  static const background = Color(0xFFFAFAFA);
  static const surface = Color(0xFFFFFFFF);
  static const cardBackground = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF3F4F6);
  
  // Text Colors
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSecondary = Color(0xFFFFFFFF);
  
  // Status Colors
  static const success = Color(0xFF10B981);
  static const successLight = Color(0xFF34D399);
  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFBBF24);
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFF87171);
  static const info = Color(0xFF3B82F6);
  static const infoLight = Color(0xFF60A5FA);
  
  // Service Status Colors
  static const pending = Color(0xFFF59E0B);
  static const inProgress = Color(0xFF3B82F6);
  static const completed = Color(0xFF10B981);
  static const cancelled = Color(0xFFEF4444);
  
  // Gradient Colors
  static const primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const backgroundGradient = LinearGradient(
    colors: [background, surfaceVariant],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Shadow Colors
  static const shadowColor = Color(0x1A000000);
  static const shadowColorLight = Color(0x0A000000);
  
  // Border Colors
  static const borderLight = Color(0xFFE5E7EB);
  static const borderMedium = Color(0xFFD1D5DB);
}
