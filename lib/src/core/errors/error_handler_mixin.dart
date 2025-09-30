import 'dart:async';
import 'package:flutter/material.dart';
import 'app_error.dart';
import 'error_recovery_service.dart';
import 'retry_policy.dart';

/// Mixin that provides convenient error handling methods for widgets and services
mixin ErrorHandlerMixin {
  /// Handles an error by showing appropriate UI feedback
  void handleError(
    BuildContext context,
    dynamic error, {
    VoidCallback? onRetry,
    bool showDialog = false,
    String? operationName,
  }) {
    final appError = _convertToAppError(error);
    final errorService = ErrorRecoveryService.instance;
    
    // Log the error
    errorService.logError(
      appError,
      StackTrace.current,
      operationName: operationName,
    );
    
    // Show appropriate UI feedback
    if (showDialog) {
      errorService.showErrorDialog(
        context,
        appError,
        onRetry: onRetry,
      );
    } else {
      errorService.showErrorSnackbar(
        context,
        appError,
        onRetry: onRetry,
      );
    }
  }

  /// Executes an operation with error handling and retry logic
  Future<T> executeWithErrorHandling<T>(
    Future<T> Function() operation, {
    RetryPolicy? retryPolicy,
    String? operationName,
  }) async {
    try {
      if (retryPolicy != null) {
        return await ErrorRecoveryService.instance.executeWithRetry(
          operation,
          retryPolicy,
          operationName: operationName,
        );
      } else {
        return await operation();
      }
    } catch (error) {
      final appError = _convertToAppError(error);
      ErrorRecoveryService.instance.logError(
        appError,
        StackTrace.current,
        operationName: operationName,
      );
      rethrow;
    }
  }

  /// Converts any error to an AppError
  AppError _convertToAppError(dynamic error) {
    if (error is AppError) {
      return error;
    }
    
    // Handle common Flutter/Dart exceptions
    if (error is TimeoutException) {
      return AppError(
        code: 'TIMEOUT_ERROR',
        userMessage: 'Operation timed out. Please try again.',
        technicalMessage: error.toString(),
        severity: ErrorSeverity.warning,
        isRetryable: true,
      );
    }
    
    if (error is FormatException) {
      return AppError(
        code: 'FORMAT_ERROR',
        userMessage: 'Invalid data format received.',
        technicalMessage: error.toString(),
        severity: ErrorSeverity.error,
        isRetryable: false,
      );
    }
    
    // Generic error fallback
    return AppError(
      code: 'UNKNOWN_ERROR',
      userMessage: 'An unexpected error occurred. Please try again.',
      technicalMessage: error.toString(),
      severity: ErrorSeverity.error,
      isRetryable: true,
    );
  }
}