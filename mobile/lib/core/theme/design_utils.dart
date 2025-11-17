import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Modern Design Utilities for ParkShare App (2025)
/// Includes: Glassmorphism, Neumorphism, Advanced Shadows, Blur Effects
class DesignUtils {
  // ============================================================================
  // MODERN SHADOWS (Multi-layer depth system)
  // ============================================================================

  /// Subtle shadow for cards (4dp elevation)
  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 8,
          offset: const Offset(0, 1),
        ),
      ];

  /// Medium shadow for elevated elements (8dp)
  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 20,
          offset: const Offset(0, 2),
        ),
      ];

  /// Large shadow for floating elements (16dp)
  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 40,
          offset: const Offset(0, 4),
        ),
      ];

  /// Extra large shadow for modals and dialogs (24dp)
  static List<BoxShadow> get shadowXl => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 60,
          offset: const Offset(0, 6),
        ),
      ];

  /// Colored shadow for primary elements (brand color glow)
  static List<BoxShadow> coloredShadow(Color color, {double opacity = 0.3}) => [
        BoxShadow(
          color: color.withOpacity(opacity),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: color.withOpacity(opacity * 0.5),
          blurRadius: 40,
          offset: const Offset(0, 4),
        ),
      ];

  // ============================================================================
  // GLASSMORPHISM (Frosted glass effect)
  // ============================================================================

  /// Glassmorphism container decoration (light theme)
  static BoxDecoration glassLight({
    double blur = 10.0,
    double opacity = 0.8,
    BorderRadius? borderRadius,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: Colors.white.withOpacity(opacity),
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      border: Border.all(
        color: borderColor ?? Colors.white.withOpacity(0.3),
        width: 1.5,
      ),
      boxShadow: shadowMd,
    );
  }

  /// Glassmorphism container decoration (dark theme)
  static BoxDecoration glassDark({
    double blur = 10.0,
    double opacity = 0.7,
    BorderRadius? borderRadius,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: const Color(0xFF1F2937).withOpacity(opacity),
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      border: Border.all(
        color: borderColor ?? Colors.white.withOpacity(0.1),
        width: 1.5,
      ),
      boxShadow: shadowMd,
    );
  }

  /// Glassmorphism widget wrapper with backdrop blur
  static Widget glassContainer({
    required Widget child,
    bool isDark = false,
    double blur = 10.0,
    double opacity = 0.8,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: isDark
              ? glassDark(blur: blur, opacity: opacity, borderRadius: borderRadius)
              : glassLight(blur: blur, opacity: opacity, borderRadius: borderRadius),
          child: child,
        ),
      ),
    );
  }

  // ============================================================================
  // NEUMORPHISM (Soft UI effect)
  // ============================================================================

  /// Neumorphism (raised) decoration
  static BoxDecoration neumorphicRaised({
    Color? backgroundColor,
    BorderRadius? borderRadius,
  }) {
    final bgColor = backgroundColor ?? AppTheme.surfaceDim;
    return BoxDecoration(
      color: bgColor,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.7),
          offset: const Offset(-6, -6),
          blurRadius: 12,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          offset: const Offset(6, 6),
          blurRadius: 12,
        ),
      ],
    );
  }

  /// Neumorphism (pressed/inset) decoration
  static BoxDecoration neumorphicPressed({
    Color? backgroundColor,
    BorderRadius? borderRadius,
  }) {
    final bgColor = backgroundColor ?? AppTheme.surfaceDim;
    return BoxDecoration(
      color: bgColor,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          offset: const Offset(-4, -4),
          blurRadius: 8,
          inset: true,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.7),
          offset: const Offset(4, 4),
          blurRadius: 8,
          inset: true,
        ),
      ],
    );
  }

  // ============================================================================
  // GRADIENT OVERLAYS
  // ============================================================================

  /// Gradient overlay for image cards (dark bottom fade)
  static BoxDecoration imageGradientOverlay({
    BorderRadius? borderRadius,
    List<Color>? colors,
  }) {
    return BoxDecoration(
      borderRadius: borderRadius,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors ??
            [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  /// Shimmer gradient for loading states
  static LinearGradient get shimmerGradient => const LinearGradient(
        colors: [
          Color(0xFFE0E0E0),
          Color(0xFFF5F5F5),
          Color(0xFFE0E0E0),
        ],
        begin: Alignment(-1.0, 0.0),
        end: Alignment(1.0, 0.0),
        stops: [0.0, 0.5, 1.0],
      );

  // ============================================================================
  // BLUR EFFECTS
  // ============================================================================

  /// Apply background blur to any widget
  static Widget blurBackground({
    required Widget child,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
  }) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
      child: child,
    );
  }

  // ============================================================================
  // BORDER RADIUS PRESETS
  // ============================================================================

  static BorderRadius get radiusXs => BorderRadius.circular(8);
  static BorderRadius get radiusSm => BorderRadius.circular(12);
  static BorderRadius get radiusMd => BorderRadius.circular(16);
  static BorderRadius get radiusLg => BorderRadius.circular(20);
  static BorderRadius get radiusXl => BorderRadius.circular(24);
  static BorderRadius get radius2xl => BorderRadius.circular(32);
  static BorderRadius get radiusFull => BorderRadius.circular(999);

  // ============================================================================
  // MODERN ANIMATION CURVES (2025)
  // ============================================================================

  /// Smooth deceleration curve (Material Design 3)
  static const Curve smoothDecelerate = Curves.easeOutCubic;

  /// Smooth acceleration curve
  static const Curve smoothAccelerate = Curves.easeInCubic;

  /// Emphasized deceleration (overshoot effect)
  static const Curve emphasized = Curves.easeOutBack;

  /// Spring curve (bounce effect)
  static const Curve spring = Curves.elasticOut;

  /// Standard Material motion
  static const Curve standard = Curves.easeInOutCubic;

  /// Quick transition
  static const Curve quick = Curves.easeOut;
}
