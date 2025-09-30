import 'package:flutter/material.dart';
import '../app_error.dart';

/// A reusable widget for displaying inline error messages
class ErrorDisplayWidget extends StatelessWidget {
  final AppError error;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final EdgeInsetsGeometry? padding;
  final bool showIcon;

  const ErrorDisplayWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.onDismiss,
    this.padding,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: error.severity.color.withValues(alpha: 0.1),
        border: Border.all(
          color: error.severity.color.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showIcon) ...[
                Icon(
                  error.severity.icon,
                  color: error.severity.color,
                  size: 20,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  error.userMessage,
                  style: TextStyle(
                    color: error.severity.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (onDismiss != null)
                InkWell(
                  onTap: onDismiss,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: error.severity.color,
                    ),
                  ),
                ),
            ],
          ),
          if (error.isRetryable && onRetry != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: error.severity.color,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('Retry'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A compact error widget for form fields
class FieldErrorWidget extends StatelessWidget {
  final AppError error;
  final EdgeInsetsGeometry? padding;

  const FieldErrorWidget({
    super.key,
    required this.error,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 4, left: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: error.severity.color,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              error.userMessage,
              style: TextStyle(
                color: error.severity.color,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A full-screen error widget for critical errors
class FullScreenErrorWidget extends StatelessWidget {
  final AppError error;
  final VoidCallback? onRetry;
  final VoidCallback? onGoBack;
  final String? illustration;

  const FullScreenErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.onGoBack,
    this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error illustration or icon
              if (illustration != null)
                Image.asset(
                  illustration!,
                  height: 200,
                  width: 200,
                )
              else
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: error.severity.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    error.severity.icon,
                    size: 60,
                    color: error.severity.color,
                  ),
                ),
              
              const SizedBox(height: 32),
              
              // Error title
              Text(
                _getErrorTitle(error.severity),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: error.severity.color,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Error message
              Text(
                error.userMessage,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Action buttons
              Column(
                children: [
                  if (error.isRetryable && onRetry != null)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onRetry,
                        child: const Text('Try Again'),
                      ),
                    ),
                  
                  if (error.isRetryable && onRetry != null && onGoBack != null)
                    const SizedBox(height: 12),
                  
                  if (onGoBack != null)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onGoBack,
                        child: const Text('Go Back'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getErrorTitle(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.info:
        return 'Information';
      case ErrorSeverity.warning:
        return 'Something\'s Not Right';
      case ErrorSeverity.error:
        return 'Oops! Something Went Wrong';
      case ErrorSeverity.critical:
        return 'Critical Error';
    }
  }
}