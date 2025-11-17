import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../theme/design_utils.dart';
import '../services/haptic_service.dart';

/// Modern button variants
enum ModernButtonVariant {
  primary,
  secondary,
  outline,
  text,
  glass,
  gradient,
}

/// Modern button sizes
enum ModernButtonSize {
  small,
  medium,
  large,
}

/// Modern Button Widget (2025 Design)
/// Features:
/// - Glassmorphism effect
/// - Haptic feedback
/// - Advanced shadows
/// - Loading state
/// - Icon support
/// - Gradient variants
class ModernButton extends StatefulWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final ModernButtonVariant variant;
  final ModernButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final bool enableHaptic;

  const ModernButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.variant = ModernButtonVariant.primary,
    this.size = ModernButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.enableHaptic = true,
  }) : assert(text != null || child != null, 'Either text or child must be provided');

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton> with SingleTickerProviderStateMixin {
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTap() {
    if (widget.onPressed == null || widget.isLoading) return;

    if (widget.enableHaptic) {
      switch (widget.variant) {
        case ModernButtonVariant.primary:
        case ModernButtonVariant.gradient:
          HapticService.mediumTap();
          break;
        case ModernButtonVariant.secondary:
        case ModernButtonVariant.glass:
          HapticService.lightTap();
          break;
        case ModernButtonVariant.outline:
        case ModernButtonVariant.text:
          HapticService.selectionChanged();
          break;
      }
    }

    widget.onPressed?.call();
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case ModernButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ModernButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ModernButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case ModernButtonSize.small:
        return 14;
      case ModernButtonSize.medium:
        return 16;
      case ModernButtonSize.large:
        return 18;
    }
  }

  BoxDecoration _getDecoration() {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    final radius = widget.borderRadius ?? DesignUtils.radiusMd;

    switch (widget.variant) {
      case ModernButtonVariant.primary:
        return BoxDecoration(
          color: isDisabled
              ? AppTheme.neutral300
              : (widget.backgroundColor ?? AppTheme.primaryColor),
          borderRadius: radius,
          boxShadow: isDisabled
              ? null
              : (_isPressed ? DesignUtils.shadowSm : DesignUtils.shadowMd),
        );

      case ModernButtonVariant.secondary:
        return BoxDecoration(
          color: isDisabled
              ? AppTheme.neutral200
              : (widget.backgroundColor ?? AppTheme.secondaryColor),
          borderRadius: radius,
          boxShadow: isDisabled
              ? null
              : (_isPressed ? DesignUtils.shadowSm : DesignUtils.shadowMd),
        );

      case ModernButtonVariant.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
          border: Border.all(
            color: isDisabled
                ? AppTheme.neutral300
                : (widget.backgroundColor ?? AppTheme.primaryColor),
            width: 2,
          ),
        );

      case ModernButtonVariant.text:
        return BoxDecoration(
          color: _isPressed
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: radius,
        );

      case ModernButtonVariant.glass:
        return DesignUtils.glassLight(
          borderRadius: radius,
          opacity: isDisabled ? 0.5 : 0.8,
        );

      case ModernButtonVariant.gradient:
        return BoxDecoration(
          gradient: isDisabled
              ? LinearGradient(
                  colors: [AppTheme.neutral300, AppTheme.neutral400],
                )
              : AppTheme.primaryGradient,
          borderRadius: radius,
          boxShadow: isDisabled
              ? null
              : DesignUtils.coloredShadow(AppTheme.primaryColor, opacity: _isPressed ? 0.2 : 0.3),
        );
    }
  }

  Color _getForegroundColor() {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    if (widget.foregroundColor != null) {
      return isDisabled ? AppTheme.neutral500 : widget.foregroundColor!;
    }

    switch (widget.variant) {
      case ModernButtonVariant.primary:
      case ModernButtonVariant.secondary:
      case ModernButtonVariant.gradient:
        return isDisabled ? AppTheme.neutral500 : Colors.white;

      case ModernButtonVariant.outline:
      case ModernButtonVariant.text:
        return isDisabled
            ? AppTheme.neutral400
            : (widget.backgroundColor ?? AppTheme.primaryColor);

      case ModernButtonVariant.glass:
        return isDisabled ? AppTheme.neutral500 : AppTheme.neutral900;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = widget.child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null && !widget.isLoading) ...[
              Icon(
                widget.icon,
                size: _getFontSize() + 4,
                color: _getForegroundColor(),
              ),
              const SizedBox(width: 8),
            ],
            if (widget.isLoading)
              SizedBox(
                width: _getFontSize() + 4,
                height: _getFontSize() + 4,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(_getForegroundColor()),
                ),
              )
            else
              Text(
                widget.text!,
                style: TextStyle(
                  fontSize: _getFontSize(),
                  fontWeight: FontWeight.w600,
                  color: _getForegroundColor(),
                  fontFamily: 'Inter',
                ),
              ),
          ],
        );

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.isFullWidth ? double.infinity : null,
          padding: _getPadding(),
          decoration: _getDecoration(),
          child: content,
        )
            .animate(target: _isPressed ? 1 : 0)
            .shimmer(
              duration: 200.ms,
              color: Colors.white.withOpacity(0.1),
            ),
      ),
    );
  }
}

/// Glass Button (Shorthand)
class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ModernButtonSize size;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.size = ModernButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return ModernButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      size: size,
      variant: ModernButtonVariant.glass,
    );
  }
}

/// Gradient Button (Shorthand)
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ModernButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      variant: ModernButtonVariant.gradient,
    );
  }
}
