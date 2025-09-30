import 'package:flutter/material.dart';
import '../../core/errors/auth_error.dart';

/// Enhanced text field with built-in error handling and validation
class EnhancedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final AuthError? error;
  final VoidCallback? onChanged;
  final VoidCallback? onClearError;
  final bool showPasswordToggle;
  final bool enabled;

  const EnhancedTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.error,
    this.onChanged,
    this.onClearError,
    this.showPasswordToggle = true,
    this.enabled = true,
  });

  @override
  State<EnhancedTextField> createState() => _EnhancedTextFieldState();
}

class _EnhancedTextFieldState extends State<EnhancedTextField> {
  bool _obscureText = true;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                _hasFocus = hasFocus;
              });
              if (hasFocus && hasError) {
                widget.onClearError?.call();
              }
            },
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword && _obscureText,
              keyboardType: widget.keyboardType,
              enabled: widget.enabled,
              onChanged: (_) => widget.onChanged?.call(),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                prefixIcon: widget.prefixIcon != null 
                    ? AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          widget.prefixIcon,
                          color: _hasFocus 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      )
                    : null,
                suffixIcon: _buildSuffixIcon(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: hasError 
                        ? theme.colorScheme.error 
                        : theme.colorScheme.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: hasError 
                        ? theme.colorScheme.error 
                        : theme.colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: hasError 
                        ? theme.colorScheme.error 
                        : theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: _hasFocus 
                    ? theme.colorScheme.surface 
                    : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                labelStyle: TextStyle(
                  color: _hasFocus 
                      ? theme.colorScheme.primary 
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          _buildErrorMessage(),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (!widget.isPassword || !widget.showPasswordToggle) {
      return null;
    }

    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility : Icons.visibility_off,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }

  Widget _buildErrorMessage() {
    final theme = Theme.of(context);
    final error = widget.error!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: error.severity.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: error.severity.color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              error.severity.icon,
              size: 16,
              color: error.severity.color,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error.userMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: error.severity.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}