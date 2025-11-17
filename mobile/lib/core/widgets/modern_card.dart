import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/design_utils.dart';
import '../services/haptic_service.dart';

/// Modern card variants
enum ModernCardVariant {
  standard, // Standard white card with shadow
  glass, // Glassmorphism effect
  outlined, // Outlined card with border
  elevated, // Card with heavy shadow
  gradient, // Card with gradient background
}

/// Modern Card Widget (2025 Design)
/// Features:
/// - Multiple variants (standard, glass, outlined, elevated, gradient)
/// - Tap interaction with haptic feedback
/// - Customizable padding and radius
/// - Optional child content
class ModernCard extends StatefulWidget {
  final Widget child;
  final ModernCardVariant variant;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Gradient? gradient;
  final bool enableHaptic;
  final double? width;
  final double? height;

  const ModernCard({
    super.key,
    required this.child,
    this.variant = ModernCardVariant.standard,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.gradient,
    this.enableHaptic = true,
    this.width,
    this.height,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap == null) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (widget.onTap == null) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTap() {
    if (widget.onTap == null) return;

    if (widget.enableHaptic) {
      HapticService.lightTap();
    }

    widget.onTap?.call();
  }

  BoxDecoration _getDecoration() {
    final radius = widget.borderRadius ?? DesignUtils.radiusLg;

    switch (widget.variant) {
      case ModernCardVariant.standard:
        return BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: radius,
          boxShadow: _isPressed ? DesignUtils.shadowSm : DesignUtils.shadowMd,
        );

      case ModernCardVariant.glass:
        return DesignUtils.glassLight(
          borderRadius: radius,
          opacity: 0.85,
        );

      case ModernCardVariant.outlined:
        return BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: radius,
          border: Border.all(
            color: AppTheme.neutral200,
            width: 1.5,
          ),
        );

      case ModernCardVariant.elevated:
        return BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: radius,
          boxShadow: _isPressed ? DesignUtils.shadowMd : DesignUtils.shadowLg,
        );

      case ModernCardVariant.gradient:
        return BoxDecoration(
          gradient: widget.gradient ?? AppTheme.primaryGradient,
          borderRadius: radius,
          boxShadow: DesignUtils.coloredShadow(
            AppTheme.primaryColor,
            opacity: _isPressed ? 0.2 : 0.3,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding ?? const EdgeInsets.all(16),
      decoration: _getDecoration(),
      child: widget.child,
    );

    // Wrap with backdrop filter if glass variant
    if (widget.variant == ModernCardVariant.glass) {
      content = ClipRRect(
        borderRadius: widget.borderRadius ?? DesignUtils.radiusLg,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: content,
        ),
      );
    }

    // Add tap interaction if onTap is provided
    if (widget.onTap != null) {
      content = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: content,
        ),
      );
    }

    return content;
  }
}

/// Glass Card (Shorthand)
class GlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      variant: ModernCardVariant.glass,
      onTap: onTap,
      padding: padding,
      borderRadius: borderRadius,
      child: child,
    );
  }
}

/// Gradient Card (Shorthand)
class GradientCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Gradient? gradient;

  const GradientCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      variant: ModernCardVariant.gradient,
      gradient: gradient,
      onTap: onTap,
      padding: padding,
      borderRadius: borderRadius,
      child: child,
    );
  }
}

/// Elevated Card (Shorthand)
class ElevatedCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const ElevatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      variant: ModernCardVariant.elevated,
      backgroundColor: backgroundColor,
      onTap: onTap,
      padding: padding,
      borderRadius: borderRadius,
      child: child,
    );
  }
}
