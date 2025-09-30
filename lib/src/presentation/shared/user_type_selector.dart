import 'package:flutter/material.dart';
import '../../data/models/user.dart';
import '../../core/errors/auth_error.dart';

/// Modern user type selector with card-based design
class UserTypeSelector extends StatefulWidget {
  final UserType? selectedType;
  final ValueChanged<UserType>? onTypeSelected;
  final AuthError? error;
  final VoidCallback? onClearError;
  final bool enabled;

  const UserTypeSelector({
    super.key,
    this.selectedType,
    this.onTypeSelected,
    this.error,
    this.onClearError,
    this.enabled = true,
  });

  @override
  State<UserTypeSelector> createState() => _UserTypeSelectorState();
}

class _UserTypeSelectorState extends State<UserTypeSelector> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I am a...',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTypeCard(
                context,
                UserType.shipper,
                Icons.local_shipping_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTypeCard(
                context,
                UserType.driver,
                Icons.drive_eta_rounded,
              ),
            ),
          ],
        ),
        if (hasError) ...[
          const SizedBox(height: 12),
          _buildErrorMessage(),
        ],
      ],
    );
  }

  Widget _buildTypeCard(BuildContext context, UserType type, IconData icon) {
    final theme = Theme.of(context);
    final isSelected = widget.selectedType == type;
    final hasError = widget.error != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: InkWell(
        onTap: widget.enabled
            ? () {
                if (hasError) {
                  widget.onClearError?.call();
                }
                widget.onTypeSelected?.call(type);
              }
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasError
                  ? theme.colorScheme.error
                  : isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : theme.colorScheme.surface,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                type.displayName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                type.description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: theme.colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Selected',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
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