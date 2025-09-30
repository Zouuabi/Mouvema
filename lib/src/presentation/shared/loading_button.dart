import 'package:flutter/material.dart';

/// A button widget with built-in loading states and smooth animations
class LoadingButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isEnabled;
  final ButtonStyle? style;
  final Widget? icon;
  final double? width;
  final double height;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isEnabled = true,
    this.style,
    this.icon,
    this.width,
    this.height = 50,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = !widget.isEnabled || widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: FilledButton(
              onPressed: isDisabled ? null : _handlePressed,
              style: widget.style ?? _defaultButtonStyle(theme),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: widget.isLoading
                    ? _buildLoadingIndicator()
                    : _buildButtonContent(),
              ),
            ),
          ),
        );
      },
    );
  }

  ButtonStyle _defaultButtonStyle(ThemeData theme) {
    return FilledButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      disabledBackgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.12),
      disabledForegroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );
  }

  Widget _buildLoadingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Loading...',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonContent() {
    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.icon!,
          const SizedBox(width: 8),
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      widget.text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _handlePressed() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onPressed?.call();
  }
}