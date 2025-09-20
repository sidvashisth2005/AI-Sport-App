import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

// Backwards-compatible alias for previous API
// Some screens import NeonButtonVariant and pass a `variant:` named arg.
// Provide a thin compatibility layer mapping to NeonButtonType.
enum NeonButtonVariant { primary, secondary, accent, tertiary, outline, text, icon }

enum NeonButtonType {
  primary,
  secondary,
  accent,
  outline,
  text,
  icon,
}

enum NeonButtonSize {
  small,
  medium,
  large,
  extraLarge,
}

class NeonButton extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final Widget? child;
  final VoidCallback? onPressed;
  final NeonButtonType type;
  // Backwards-compatible variant param
  final NeonButtonVariant? variant;
  final NeonButtonSize size;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final bool enabled;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double elevation;
  final bool showGlow;
  final bool hapticFeedback;
  final Duration animationDuration;
  
  const NeonButton({
    super.key,
    this.text,
    this.icon,
    this.child,
    this.onPressed,
    this.type = NeonButtonType.primary,
    this.variant,
    this.size = NeonButtonSize.medium,
    this.color,
    this.textColor,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 16.0,
    this.elevation = 8.0,
    this.showGlow = true,
    this.hapticFeedback = true,
    this.animationDuration = const Duration(milliseconds: 200),
  }) : assert(text != null || icon != null || child != null,
               'NeonButton must have either text, icon, or child');

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _buttonColor {
    if (widget.color != null) return widget.color!;
    // Map legacy variant to current type if provided
    final NeonButtonType effectiveType = widget.variant != null
        ? _mapVariantToType(widget.variant!)
        : widget.type;
    
    switch (effectiveType) {
      case NeonButtonType.primary:
        return AppColors.royalPurple;
      case NeonButtonType.secondary:
        return AppColors.electricBlue;
      case NeonButtonType.accent:
        return AppColors.neonGreen;
      case NeonButtonType.outline:
      case NeonButtonType.text:
      case NeonButtonType.icon:
        return AppColors.electricBlue;
    }
  }

  Color get _textColor {
    if (widget.textColor != null) return widget.textColor!;
    final NeonButtonType effectiveType = widget.variant != null
        ? _mapVariantToType(widget.variant!)
        : widget.type;
    
    switch (effectiveType) {
      case NeonButtonType.primary:
      case NeonButtonType.secondary:
        return AppColors.textPrimary;
      case NeonButtonType.accent:
        return AppColors.deepCharcoal;
      case NeonButtonType.outline:
      case NeonButtonType.text:
      case NeonButtonType.icon:
        return _buttonColor;
    }
  }

  EdgeInsetsGeometry get _padding {
    if (widget.padding != null) return widget.padding!;
    
    switch (widget.size) {
      case NeonButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case NeonButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case NeonButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
      case NeonButtonSize.extraLarge:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case NeonButtonSize.small:
        return 12;
      case NeonButtonSize.medium:
        return 14;
      case NeonButtonSize.large:
        return 16;
      case NeonButtonSize.extraLarge:
        return 18;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case NeonButtonSize.small:
        return 16;
      case NeonButtonSize.medium:
        return 20;
      case NeonButtonSize.large:
        return 24;
      case NeonButtonSize.extraLarge:
        return 28;
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled || widget.isLoading) return;
    
    setState(() {
      _isPressed = true;
    });
    _controller.forward();
    
    if (widget.hapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  void _handleTapCancel() {
    _handleTapEnd();
  }

  void _handleTapEnd() {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  void _handleTap() {
    if (!widget.enabled || widget.isLoading) return;
    
    if (widget.hapticFeedback) {
      HapticFeedback.selectionClick();
    }
    
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = !widget.enabled || widget.isLoading;
    final Color buttonColor = isDisabled 
        ? AppColors.buttonDisabled 
        : _buttonColor;
    final Color textColor = isDisabled 
        ? AppColors.textDisabled 
        : _textColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            decoration: _buildDecoration(buttonColor),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleTap,
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Container(
                  padding: _padding,
                  child: _buildContent(textColor),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _buildDecoration(Color buttonColor) {
    final NeonButtonType effectiveType = widget.variant != null
        ? _mapVariantToType(widget.variant!)
        : widget.type;
    switch (effectiveType) {
      case NeonButtonType.primary:
      case NeonButtonType.secondary:
      case NeonButtonType.accent:
        return BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: widget.showGlow ? [
            BoxShadow(
              color: buttonColor.withOpacity(0.5 * _glowAnimation.value),
              blurRadius: widget.elevation * _glowAnimation.value,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: buttonColor.withOpacity(0.3 * _glowAnimation.value),
              blurRadius: widget.elevation * 2 * _glowAnimation.value,
              spreadRadius: 0,
            ),
          ] : null,
        );
      
      case NeonButtonType.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: buttonColor,
            width: 2,
          ),
          boxShadow: widget.showGlow ? [
            BoxShadow(
              color: buttonColor.withOpacity(0.3 * _glowAnimation.value),
              blurRadius: widget.elevation * _glowAnimation.value,
              spreadRadius: 0,
            ),
          ] : null,
        );
      
      case NeonButtonType.text:
      case NeonButtonType.icon:
        return BoxDecoration(
          color: _isPressed 
              ? buttonColor.withOpacity(0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        );
    }
  }

  NeonButtonType _mapVariantToType(NeonButtonVariant variant) {
    switch (variant) {
      case NeonButtonVariant.primary:
        return NeonButtonType.primary;
      case NeonButtonVariant.secondary:
        return NeonButtonType.secondary;
      case NeonButtonVariant.accent:
        return NeonButtonType.accent;
      case NeonButtonVariant.tertiary:
        return NeonButtonType.accent;
      case NeonButtonVariant.outline:
        return NeonButtonType.outline;
      case NeonButtonVariant.text:
        return NeonButtonType.text;
      case NeonButtonVariant.icon:
        return NeonButtonType.icon;
    }
  }

  Widget _buildContent(Color textColor) {
    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          width: _iconSize,
          height: _iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        ),
      );
    }

    if (widget.child != null) {
      return Center(child: widget.child!);
    }

    if (widget.icon != null && widget.text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            size: _iconSize,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Text(
            widget.text!,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      );
    }

    if (widget.icon != null) {
      return Center(
        child: Icon(
          widget.icon,
          size: _iconSize,
          color: textColor,
        ),
      );
    }

    return Center(
      child: Text(
        widget.text!,
        style: TextStyle(
          fontSize: _fontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Predefined button variants
class PrimaryNeonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final double? width;
  final IconData? icon;
  
  const PrimaryNeonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return NeonButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      type: NeonButtonType.primary,
      size: NeonButtonSize.large,
      isLoading: isLoading,
      enabled: enabled,
      width: width,
    );
  }
}

class SecondaryNeonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final double? width;
  final IconData? icon;
  
  const SecondaryNeonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return NeonButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      type: NeonButtonType.secondary,
      size: NeonButtonSize.large,
      isLoading: isLoading,
      enabled: enabled,
      width: width,
    );
  }
}

class AccentNeonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final double? width;
  final IconData? icon;
  
  const AccentNeonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return NeonButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      type: NeonButtonType.accent,
      size: NeonButtonSize.large,
      isLoading: isLoading,
      enabled: enabled,
      width: width,
    );
  }
}

class OutlineNeonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final double? width;
  final IconData? icon;
  
  const OutlineNeonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return NeonButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      type: NeonButtonType.outline,
      size: NeonButtonSize.large,
      isLoading: isLoading,
      enabled: enabled,
      width: width,
    );
  }
}

class IconNeonButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Color? color;
  final NeonButtonSize size;
  
  const IconNeonButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.color,
    this.size = NeonButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return NeonButton(
      icon: icon,
      onPressed: onPressed,
      type: NeonButtonType.icon,
      size: size,
      isLoading: isLoading,
      enabled: enabled,
      color: color,
    );
  }
}