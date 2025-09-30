import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

import 'app_error.dart';
import 'retry_policy.dart';

/// Service for handling error recovery, retry logic, and user feedback
class ErrorRecoveryService {
  static ErrorRecoveryService? _instance;
  static ErrorRecoveryService get instance => _instance ??= ErrorRecoveryService._();
  
  ErrorRecoveryService._();

  /// Executes an operation with retry logic based on the provided policy
  Future<T> executeWithRetry<T>(
    Future<T> Function() operation,
    RetryPolicy policy, {
    String? operationName,
  }) async {
    int attemptCount = 0;
    AppError? lastError;

    while (attemptCount < policy.maxAttempts) {
      attemptCount++;
      
      try {
        final result = await operation();
        
        // Log successful retry if this wasn't the first attempt
        if (attemptCount > 1) {
          developer.log(
            'Operation succeeded on attempt $attemptCount',
            name: 'ErrorRecoveryService',
          );
        }
        
        return result;
      } catch (error) {
        AppError appError;
        
        if (error is AppError) {
          appError = error;
        } else {
          // Convert generic errors to AppError
          appError = AppError(
            code: 'UNKNOWN_ERROR',
            userMessage: 'An unexpected error occurred',
            technicalMessage: error.toString(),
            severity: ErrorSeverity.error,
            isRetryable: true,
          );
        }
        
        lastError = appError;
        
        // Check if we should retry
        final shouldRetry = attemptCount < policy.maxAttempts && 
                           (appError.isRetryable || policy.isRetryable(appError.code));
        
        if (!shouldRetry) {
          break;
        }
        
        // Wait before retrying
        final delay = policy.getDelayForAttempt(attemptCount);
        if (delay > Duration.zero) {
          developer.log(
            'Retrying operation in ${delay.inMilliseconds}ms (attempt $attemptCount/${policy.maxAttempts})',
            name: 'ErrorRecoveryService',
          );
          await Future.delayed(delay);
        }
      }
    }
    
    // All retries exhausted, throw the last error
    if (lastError != null) {
      logError(lastError, StackTrace.current, operationName: operationName);
      throw lastError;
    }
    
    // This should never happen, but just in case
    throw AppError(
      code: 'RETRY_EXHAUSTED',
      userMessage: 'Operation failed after multiple attempts',
      severity: ErrorSeverity.error,
    );
  }

  /// Shows an error dialog to the user
  void showErrorDialog(
    BuildContext context,
    AppError error, {
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(
          error.severity.icon,
          color: error.severity.color,
          size: 32,
        ),
        title: Text(_getErrorTitle(error.severity)),
        content: Text(error.userMessage),
        actions: [
          if (onDismiss != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDismiss();
              },
              child: const Text('Cancel'),
            ),
          if (error.isRetryable && onRetry != null)
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Retry'),
            )
          else
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
        ],
      ),
    );
  }

  /// Shows an error snackbar to the user
  void showErrorSnackbar(
    BuildContext context,
    AppError error, {
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    
    // Clear any existing snackbars
    messenger.clearSnackBars();
    
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              error.severity.icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                error.userMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: error.severity.color,
        duration: duration,
        action: error.isRetryable && onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  /// Logs an error for debugging and monitoring
  void logError(
    AppError error,
    StackTrace stackTrace, {
    String? operationName,
  }) {
    final operation = operationName != null ? ' [$operationName]' : '';
    
    developer.log(
      '${error.code}$operation: ${error.userMessage}',
      name: 'ErrorRecoveryService',
      error: error.technicalMessage ?? error.userMessage,
      stackTrace: stackTrace,
      level: _getLogLevel(error.severity),
    );
    
    // In a production app, you might also send this to a crash reporting service
    // like Firebase Crashlytics, Sentry, etc.
  }

  /// Gets appropriate title for error severity
  String _getErrorTitle(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.info:
        return 'Information';
      case ErrorSeverity.warning:
        return 'Warning';
      case ErrorSeverity.error:
        return 'Error';
      case ErrorSeverity.critical:
        return 'Critical Error';
    }
  }

  /// Converts error severity to log level
  int _getLogLevel(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.info:
        return 800; // INFO
      case ErrorSeverity.warning:
        return 900; // WARNING
      case ErrorSeverity.error:
        return 1000; // SEVERE
      case ErrorSeverity.critical:
        return 1200; // SHOUT
    }
  }
}