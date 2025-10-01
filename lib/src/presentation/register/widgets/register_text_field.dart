import 'package:flutter/material.dart';
import '../../../core/errors/auth_error.dart';

/// Simple text field widget specifically for registration
class RegisterTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final AuthError? error;
  final VoidCallback? onChanged;
  final bool enabled;

  const RegisterTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.error,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<RegisterTextField> createState() => _RegisterTextFieldState();
}

class _RegisterTextFieldState extends State<RegisterTextField> {
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError 
                  ? theme.colorScheme.error 
                  : _hasFocus 
                      ? theme.colorScheme.primary 
                      : theme.colorScheme.outline,
              width: _hasFocus ? 2 : 1,
            ),
          ),
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                _hasFocus = hasFocus;
              });
            },
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword && _obscureText,
              keyboardType: widget.keyboardType,
              enabled: widget.enabled,
              onChanged: (_) => widget.onChanged?.call(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                prefixIcon: widget.prefixIcon != null 
                    ? Icon(
                        widget.prefixIcon,
                        color: _hasFocus 
                            ? theme.colorScheme.primary 
                            : theme.colorScheme.onSurfaceVariant,
                      )
                    : null,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 16,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.error!.userMessage,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}