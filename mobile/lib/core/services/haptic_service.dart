import 'package:flutter/services.dart';

/// Modern Haptic Feedback Service
/// Provides tactile feedback for user interactions (2025 standard)
class HapticService {
  // Prevent instantiation
  HapticService._();

  // ============================================================================
  // LIGHT HAPTICS (Subtle feedback)
  // ============================================================================

  /// Light tap feedback (button press, toggle)
  static Future<void> lightTap() async {
    await HapticFeedback.lightImpact();
  }

  /// Selection changed (picker, slider)
  static Future<void> selectionChanged() async {
    await HapticFeedback.selectionClick();
  }

  // ============================================================================
  // MEDIUM HAPTICS (Standard feedback)
  // ============================================================================

  /// Medium tap feedback (card tap, navigation)
  static Future<void> mediumTap() async {
    await HapticFeedback.mediumImpact();
  }

  // ============================================================================
  // HEAVY HAPTICS (Strong feedback)
  // ============================================================================

  /// Heavy tap feedback (important action, confirmation)
  static Future<void> heavyTap() async {
    await HapticFeedback.heavyImpact();
  }

  // ============================================================================
  // SEMANTIC HAPTICS (Contextual feedback)
  // ============================================================================

  /// Success feedback (booking confirmed, payment successful)
  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  /// Error feedback (booking failed, validation error)
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Warning feedback (low battery, time running out)
  static Future<void> warning() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Notification feedback (new message, booking update)
  static Future<void> notification() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  // ============================================================================
  // INTERACTION HAPTICS (UI-specific)
  // ============================================================================

  /// Pull to refresh feedback
  static Future<void> pullToRefresh() async {
    await HapticFeedback.mediumImpact();
  }

  /// Swipe action feedback (swipe to delete, etc.)
  static Future<void> swipeAction() async {
    await HapticFeedback.lightImpact();
  }

  /// Long press feedback
  static Future<void> longPress() async {
    await HapticFeedback.heavyImpact();
  }

  /// Toggle switch feedback
  static Future<void> toggle() async {
    await HapticFeedback.lightImpact();
  }

  /// Favorite/bookmark feedback
  static Future<void> favorite() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  // ============================================================================
  // NAVIGATION HAPTICS
  // ============================================================================

  /// Tab changed feedback
  static Future<void> tabChanged() async {
    await HapticFeedback.selectionClick();
  }

  /// Page swiped feedback
  static Future<void> pageSwiped() async {
    await HapticFeedback.lightImpact();
  }

  /// Modal opened feedback
  static Future<void> modalOpened() async {
    await HapticFeedback.mediumImpact();
  }

  /// Modal closed feedback
  static Future<void> modalClosed() async {
    await HapticFeedback.lightImpact();
  }

  // ============================================================================
  // VIBRATION PATTERNS (Android only - iOS uses taptic engine)
  // ============================================================================

  /// Custom vibration pattern (duration in milliseconds)
  static Future<void> customVibrate(Duration duration) async {
    await HapticFeedback.vibrate();
    // Note: For more complex patterns, use the vibration package
  }
}

/// Extension for easy haptic feedback on widgets
extension HapticGesture on Widget {
  /// Wrap widget with light haptic feedback on tap
  Widget withLightHaptic(VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              HapticService.lightTap();
              onTap();
            },
      child: this,
    );
  }

  /// Wrap widget with medium haptic feedback on tap
  Widget withMediumHaptic(VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              HapticService.mediumTap();
              onTap();
            },
      child: this,
    );
  }

  /// Wrap widget with heavy haptic feedback on tap
  Widget withHeavyHaptic(VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              HapticService.heavyTap();
              onTap();
            },
      child: this,
    );
  }
}
