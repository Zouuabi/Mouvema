import 'package:flutter/material.dart';
import '../../core/errors/auth_error.dart';

/// Enhanced date picker field with modern styling
class DatePickerField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final AuthError? error;
  final ValueChanged<DateTime>? onDateSelected;
  final VoidCallback? onClearError;
  final bool enabled;

  const DatePickerField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    this.error,
    this.onDateSelected,
    this.onClearError,
    this.enabled = true,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: InkWell(
            onTap: widget.enabled ? _selectDate : null,
            borderRadius: BorderRadius.circular(16),
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _hasFocus = hasFocus;
                });
                if (hasFocus && hasError) {
                  widget.onClearError?.call();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: hasError
                        ? theme.colorScheme.error
                        : _hasFocus
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                    width: _hasFocus ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  color: _hasFocus
                      ? theme.colorScheme.surface
                      : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
                child: Row(
                  children: [
                    if (widget.prefixIcon != null) ...[
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          widget.prefixIcon,
                          color: _hasFocus
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.labelText,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _hasFocus
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.selectedDate != null
                                ? _formatDate(widget.selectedDate!)
                                : widget.hintText,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: widget.selectedDate != null
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                              fontWeight: widget.selectedDate != null
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ],
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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              headerBackgroundColor: Theme.of(context).colorScheme.primary,
              headerForegroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != widget.selectedDate) {
      widget.onDateSelected?.call(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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