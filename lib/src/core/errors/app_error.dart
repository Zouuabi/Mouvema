import 'package:flutter/material.dart';

/// Comprehensive error model for the application
class AppError {
  final String code;
  final String userMessage;
  final String? technicalMessage;
  final ErrorSeverity severity;
  final bool isRetryable;
  final Map<String, dynamic>? context;
  final DateTime timestamp;

  AppError({
    required this.code,
    required this.userMessage,
    this.technicalMessage,
    required this.severity,
    this.isRetryable = false,
    this.context,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'AppError(code: $code, userMessage: $userMessage, severity: $severity, isRetryable: $isRetryable)';
  }

  /// Creates a copy of this error with updated fields
  AppError copyWith({
    String? code,
    String? userMessage,
    String? technicalMessage,
    ErrorSeverity? severity,
    bool? isRetryable,
    Map<String, dynamic>? context,
    DateTime? timestamp,
  }) {
    return AppError(
      code: code ?? this.code,
      userMessage: userMessage ?? this.userMessage,
      technicalMessage: technicalMessage ?? this.technicalMessage,
      severity: severity ?? this.severity,
      isRetryable: isRetryable ?? this.isRetryable,
      context: context ?? this.context,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// Error severity levels
enum ErrorSeverity {
  info,
  warning,
  error,
  critical;

  /// Returns the appropriate color for the error severity
  Color get color {
    switch (this) {
      case ErrorSeverity.info:
        return Colors.blue;
      case ErrorSeverity.warning:
        return Colors.orange;
      case ErrorSeverity.error:
        return Colors.red;
      case ErrorSeverity.critical:
        return Colors.red.shade900;
    }
  }

  /// Returns the appropriate icon for the error severity
  IconData get icon {
    switch (this) {
      case ErrorSeverity.info:
        return Icons.info_outline;
      case ErrorSeverity.warning:
        return Icons.warning_amber_outlined;
      case ErrorSeverity.error:
        return Icons.error_outline;
      case ErrorSeverity.critical:
        return Icons.dangerous_outlined;
    }
  }
}