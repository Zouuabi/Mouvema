import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'app_error.dart';
import 'error_types.dart';

/// Authentication-specific error model with field-specific error handling
class AuthError extends AppError {
  final String? field;
  final AuthErrorType type;

  AuthError({
    required this.type,
    this.field,
    String? code,
    String? userMessage,
    String? technicalMessage,
    ErrorSeverity? severity,
    bool? isRetryable,
    Map<String, dynamic>? context,
  }) : super(
          code: code ?? type.toAppError().code,
          userMessage: userMessage ?? type.toAppError().userMessage,
          technicalMessage: technicalMessage,
          severity: severity ?? type.toAppError().severity,
          isRetryable: isRetryable ?? type.toAppError().isRetryable,
          context: context,
        );

  /// Creates an AuthError from a Firebase Auth Exception
  factory AuthError.fromFirebaseException(FirebaseAuthException exception,
      {String? field}) {
    AuthErrorType type;
    String? technicalMessage = exception.message;

    switch (exception.code) {
      case 'invalid-email':
        type = AuthErrorType.invalidEmail;
        break;
      case 'wrong-password':
      case 'invalid-credential':
        type = AuthErrorType.wrongPassword;
        break;
      case 'user-not-found':
        type = AuthErrorType.userNotFound;
        break;
      case 'email-already-in-use':
        type = AuthErrorType.emailAlreadyExists;
        break;
      case 'weak-password':
        type = AuthErrorType.weakPassword;
        break;
      case 'user-disabled':
        type = AuthErrorType.accountDisabled;
        break;
      case 'too-many-requests':
        type = AuthErrorType.tooManyRequests;
        break;
      case 'network-request-failed':
        type = AuthErrorType.networkError;
        break;
      case 'operation-not-allowed':
        type = AuthErrorType.serverError;
        break;
      case 'invalid-verification-code':
      case 'invalid-verification-id':
        type = AuthErrorType.serverError;
        break;
      default:
        type = AuthErrorType.serverError;
        break;
    }

    return AuthError(
      type: type,
      field: field,
      technicalMessage: technicalMessage,
    );
  }

  /// Creates an AuthError for field validation
  factory AuthError.validation({
    required String field,
    required ValidationErrorType validationType,
    String? customMessage,
  }) {
    AuthErrorType type;
    String message = customMessage ?? '';

    switch (validationType) {
      case ValidationErrorType.required:
        type = field == 'email'
            ? AuthErrorType.invalidEmail
            : AuthErrorType.weakPassword;
        message = customMessage ?? '$field is required';
        break;
      case ValidationErrorType.invalidFormat:
        type = AuthErrorType.invalidEmail;
        message = customMessage ?? 'Please enter a valid email address';
        break;
      case ValidationErrorType.tooShort:
        type = AuthErrorType.weakPassword;
        message = customMessage ?? 'Password must be at least 8 characters';
        break;
      default:
        type = AuthErrorType.serverError;
        message = customMessage ?? 'Validation error';
        break;
    }

    return AuthError(
      type: type,
      field: field,
      userMessage: message,
    );
  }

  @override
  String toString() {
    return 'AuthError(type: $type, field: $field, code: $code, userMessage: $userMessage)';
  }
}

/// Email validation utility
class EmailValidator {
  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  static AuthError? validate(String email) {
    if (email.isEmpty) {
      return AuthError.validation(
        field: 'email',
        validationType: ValidationErrorType.required,
        customMessage: 'Email is required',
      );
    }

    if (!_emailRegex.hasMatch(email)) {
      return AuthError.validation(
        field: 'email',
        validationType: ValidationErrorType.invalidFormat,
        customMessage: 'Please enter a valid email address',
      );
    }

    return null;
  }
}

/// Password validation utility
class PasswordValidator {
  static AuthError? validate(String password) {
    if (password.isEmpty) {
      return AuthError.validation(
        field: 'password',
        validationType: ValidationErrorType.required,
        customMessage: 'Password is required',
      );
    }

    if (password.length < 8) {
      return AuthError.validation(
        field: 'password',
        validationType: ValidationErrorType.tooShort,
        customMessage: 'Password must be at least 8 characters long',
      );
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return AuthError.validation(
        field: 'password',
        validationType: ValidationErrorType.invalidFormat,
        customMessage: 'Password must contain at least one uppercase letter',
      );
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return AuthError.validation(
        field: 'password',
        validationType: ValidationErrorType.invalidFormat,
        customMessage: 'Password must contain at least one lowercase letter',
      );
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return AuthError.validation(
        field: 'password',
        validationType: ValidationErrorType.invalidFormat,
        customMessage: 'Password must contain at least one number',
      );
    }

    return null;
  }

  static PasswordStrength getStrength(String password) {
    if (password.isEmpty) return PasswordStrength.empty;
    if (password.length < 8) return PasswordStrength.weak;

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasNumbers = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int score = 0;
    if (hasUppercase) score++;
    if (hasLowercase) score++;
    if (hasNumbers) score++;
    if (hasSpecialChars) score++;

    if (score >= 3 && password.length >= 12) return PasswordStrength.strong;
    if (score >= 2 && password.length >= 8) return PasswordStrength.medium;
    return PasswordStrength.weak;
  }
}

/// Password strength levels
enum PasswordStrength {
  empty,
  weak,
  medium,
  strong;

  String get label {
    switch (this) {
      case PasswordStrength.empty:
        return '';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  Color get color {
    switch (this) {
      case PasswordStrength.empty:
        return Colors.grey;
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.green;
    }
  }
}
