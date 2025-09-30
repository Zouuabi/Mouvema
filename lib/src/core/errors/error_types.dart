import 'app_error.dart';

/// Authentication-specific error types
enum AuthErrorType {
  invalidEmail,
  wrongPassword,
  emailAlreadyExists,
  weakPassword,
  networkError,
  serverError,
  userNotFound,
  accountDisabled,
  tooManyRequests;

  AppError toAppError() {
    switch (this) {
      case AuthErrorType.invalidEmail:
        return AppError(
          code: 'AUTH_INVALID_EMAIL',
          userMessage: 'Please enter a valid email address',
          severity: ErrorSeverity.warning,
          isRetryable: false,
        );
      case AuthErrorType.wrongPassword:
        return AppError(
          code: 'AUTH_WRONG_PASSWORD',
          userMessage: 'Incorrect password. Please try again.',
          severity: ErrorSeverity.error,
          isRetryable: true,
        );
      case AuthErrorType.emailAlreadyExists:
        return AppError(
          code: 'AUTH_EMAIL_EXISTS',
          userMessage: 'An account with this email already exists',
          severity: ErrorSeverity.warning,
          isRetryable: false,
        );
      case AuthErrorType.weakPassword:
        return AppError(
          code: 'AUTH_WEAK_PASSWORD',
          userMessage: 'Password must be at least 8 characters with uppercase, lowercase, and numbers',
          severity: ErrorSeverity.warning,
          isRetryable: false,
        );
      case AuthErrorType.networkError:
        return AppError(
          code: 'AUTH_NETWORK_ERROR',
          userMessage: 'Connection error. Please check your internet and try again.',
          severity: ErrorSeverity.error,
          isRetryable: true,
        );
      case AuthErrorType.serverError:
        return AppError(
          code: 'AUTH_SERVER_ERROR',
          userMessage: 'Server error. Please try again later.',
          severity: ErrorSeverity.error,
          isRetryable: true,
        );
      case AuthErrorType.userNotFound:
        return AppError(
          code: 'AUTH_USER_NOT_FOUND',
          userMessage: 'No account found with this email address',
          severity: ErrorSeverity.warning,
          isRetryable: false,
        );
      case AuthErrorType.accountDisabled:
        return AppError(
          code: 'AUTH_ACCOUNT_DISABLED',
          userMessage: 'This account has been disabled. Please contact support.',
          severity: ErrorSeverity.error,
          isRetryable: false,
        );
      case AuthErrorType.tooManyRequests:
        return AppError(
          code: 'AUTH_TOO_MANY_REQUESTS',
          userMessage: 'Too many attempts. Please wait a moment before trying again.',
          severity: ErrorSeverity.warning,
          isRetryable: true,
        );
    }
  }
}

/// Network-specific error types
enum NetworkErrorType {
  connectionTimeout,
  noInternetConnection,
  serverUnavailable,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  internalServerError;

  AppError toAppError() {
    switch (this) {
      case NetworkErrorType.connectionTimeout:
        return AppError(
          code: 'NETWORK_TIMEOUT',
          userMessage: 'Request timed out. Please try again.',
          severity: ErrorSeverity.warning,
          isRetryable: true,
        );
      case NetworkErrorType.noInternetConnection:
        return AppError(
          code: 'NETWORK_NO_INTERNET',
          userMessage: 'No internet connection. Please check your network settings.',
          severity: ErrorSeverity.error,
          isRetryable: true,
        );
      case NetworkErrorType.serverUnavailable:
        return AppError(
          code: 'NETWORK_SERVER_UNAVAILABLE',
          userMessage: 'Service temporarily unavailable. Please try again later.',
          severity: ErrorSeverity.error,
          isRetryable: true,
        );
      case NetworkErrorType.badRequest:
        return AppError(
          code: 'NETWORK_BAD_REQUEST',
          userMessage: 'Invalid request. Please check your input and try again.',
          severity: ErrorSeverity.warning,
          isRetryable: false,
        );
      case NetworkErrorType.unauthorized:
        return AppError(
          code: 'NETWORK_UNAUTHORIZED',
          userMessage: 'Session expired. Please log in again.',
          severity: ErrorSeverity.error,
          isRetryable: false,
        );
      case NetworkErrorType.forbidden:
        return AppError(
          code: 'NETWORK_FORBIDDEN',
          userMessage: 'Access denied. You don\'t have permission for this action.',
          severity: ErrorSeverity.error,
          isRetryable: false,
        );
      case NetworkErrorType.notFound:
        return AppError(
          code: 'NETWORK_NOT_FOUND',
          userMessage: 'Requested resource not found.',
          severity: ErrorSeverity.warning,
          isRetryable: false,
        );
      case NetworkErrorType.internalServerError:
        return AppError(
          code: 'NETWORK_INTERNAL_ERROR',
          userMessage: 'Server error occurred. Please try again later.',
          severity: ErrorSeverity.error,
          isRetryable: true,
        );
    }
  }
}

/// Map and geocoding error types
enum MapErrorType {
  locationPermissionDenied,
  locationServiceDisabled,
  geocodingFailed,
  mapLoadingFailed,
  gpsUnavailable,
  invalidCoordinates;

  AppError toAppError() {
    switch (this) {
      case MapErrorType.locationPermissionDenied:
        return AppError(
          code: 'MAP_PERMISSION_DENIED',
          userMessage: 'Location permission required. Please enable location access in settings.',
          severity: ErrorSeverity.warning,
          isRetryable: false,
        );
      case MapErrorType.locationServiceDisabled:
        return AppError(
          code: 'MAP_SERVICE_DISABLED',
          userMessage: 'Location services are disabled. Please enable GPS in your device settings.',
          severity: ErrorSeverity.warning,
          isRetryable: false,
        );
      case MapErrorType.geocodingFailed:
        return AppError(
          code: 'MAP_GEOCODING_FAILED',
          userMessage: 'Unable to get location name. Coordinates will be used instead.',
          severity: ErrorSeverity.info,
          isRetryable: true,
        );
      case MapErrorType.mapLoadingFailed:
        return AppError(
          code: 'MAP_LOADING_FAILED',
          userMessage: 'Map failed to load. Please check your internet connection.',
          severity: ErrorSeverity.error,
          isRetryable: true,
        );
      case MapErrorType.gpsUnavailable:
        return AppError(
          code: 'MAP_GPS_UNAVAILABLE',
          userMessage: 'GPS signal unavailable. Please try again in an open area.',
          severity: ErrorSeverity.warning,
          isRetryable: true,
        );
      case MapErrorType.invalidCoordinates:
        return AppError(
          code: 'MAP_INVALID_COORDINATES',
          userMessage: 'Invalid location coordinates. Please select a valid location.',
          severity: ErrorSeverity.warning,
          isRetryable: false,
        );
    }
  }
}

/// Form validation error types
enum ValidationErrorType {
  required,
  invalidFormat,
  tooShort,
  tooLong,
  invalidRange,
  mismatch;

  AppError toAppError({String? fieldName, Map<String, dynamic>? context}) {
    final field = fieldName ?? 'Field';
    switch (this) {
      case ValidationErrorType.required:
        return AppError(
          code: 'VALIDATION_REQUIRED',
          userMessage: '$field is required',
          severity: ErrorSeverity.warning,
          isRetryable: false,
          context: context,
        );
      case ValidationErrorType.invalidFormat:
        return AppError(
          code: 'VALIDATION_INVALID_FORMAT',
          userMessage: '$field format is invalid',
          severity: ErrorSeverity.warning,
          isRetryable: false,
          context: context,
        );
      case ValidationErrorType.tooShort:
        return AppError(
          code: 'VALIDATION_TOO_SHORT',
          userMessage: '$field is too short',
          severity: ErrorSeverity.warning,
          isRetryable: false,
          context: context,
        );
      case ValidationErrorType.tooLong:
        return AppError(
          code: 'VALIDATION_TOO_LONG',
          userMessage: '$field is too long',
          severity: ErrorSeverity.warning,
          isRetryable: false,
          context: context,
        );
      case ValidationErrorType.invalidRange:
        return AppError(
          code: 'VALIDATION_INVALID_RANGE',
          userMessage: '$field value is out of range',
          severity: ErrorSeverity.warning,
          isRetryable: false,
          context: context,
        );
      case ValidationErrorType.mismatch:
        return AppError(
          code: 'VALIDATION_MISMATCH',
          userMessage: '$field does not match',
          severity: ErrorSeverity.warning,
          isRetryable: false,
          context: context,
        );
    }
  }
}