# Enhanced Error Handling System

This directory contains a comprehensive error handling foundation for the Mouvema application. The system provides consistent error management, retry logic, and user feedback across the entire application.

## Components

### Core Models
- **AppError**: Main error model with severity levels and retry capabilities
- **ErrorSeverity**: Enum defining error severity (info, warning, error, critical)
- **RetryPolicy**: Configurable retry logic with exponential backoff
- **Error Types**: Domain-specific error enums (Auth, Network, Map, Validation)

### Services
- **ErrorRecoveryService**: Central service for error handling and retry logic
- **ErrorHandlerMixin**: Convenient mixin for widgets and services

### Widgets
- **ErrorDisplayWidget**: Inline error display with retry options
- **FieldErrorWidget**: Compact error display for form fields
- **FullScreenErrorWidget**: Full-screen error display for critical errors
- **LoadingStateWidget**: Consistent loading indicators
- **CompactLoadingWidget**: Small loading indicators for buttons
- **ShimmerLoadingWidget**: Animated shimmer effect for loading states

## Usage Examples

### Basic Error Handling

```dart
import 'package:mouvema/src/core/errors/errors.dart';

class MyWidget extends StatelessWidget with ErrorHandlerMixin {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await someOperation();
        } catch (error) {
          handleError(context, error, onRetry: () => someOperation());
        }
      },
      child: Text('Perform Operation'),
    );
  }
}
```

### Using Retry Logic

```dart
Future<void> authenticateUser() async {
  try {
    final result = await ErrorRecoveryService.instance.executeWithRetry(
      () => authService.login(email, password),
      RetryPolicy.auth,
      operationName: 'User Authentication',
    );
    // Handle success
  } catch (error) {
    // Handle final error after retries
  }
}
```

### Displaying Errors in UI

```dart
// Inline error display
ErrorDisplayWidget(
  error: authError,
  onRetry: () => retryAuthentication(),
  onDismiss: () => clearError(),
)

// Field-specific error
FieldErrorWidget(
  error: validationError,
)

// Full-screen error
FullScreenErrorWidget(
  error: criticalError,
  onRetry: () => retryOperation(),
  onGoBack: () => Navigator.pop(context),
)
```

### Creating Custom Errors

```dart
// Using predefined error types
final authError = AuthErrorType.wrongPassword.toAppError();

// Creating custom errors
final customError = AppError(
  code: 'CUSTOM_ERROR',
  userMessage: 'Something specific went wrong',
  severity: ErrorSeverity.warning,
  isRetryable: true,
);
```

### Loading States

```dart
// Standard loading indicator
LoadingStateWidget(
  message: 'Authenticating...',
)

// Progress indicator
LoadingStateWidget(
  message: 'Uploading...',
  progress: 0.7,
  showProgress: true,
)

// Button loading state
CompactLoadingWidget(
  label: 'Signing in...',
)
```

## Best Practices

1. **Use specific error types** for different domains (auth, network, validation)
2. **Provide meaningful user messages** that guide users on what to do next
3. **Implement retry logic** for transient errors (network issues, server errors)
4. **Log errors appropriately** for debugging while protecting user privacy
5. **Show consistent UI feedback** using the provided widgets
6. **Handle offline scenarios** gracefully with appropriate fallbacks

## Integration with Requirements

This error handling system addresses the following requirements:

- **6.1**: Network error handling with user-friendly messages and retry options
- **6.2**: Field-specific validation errors with contextual guidance  
- **6.4**: Graceful error screens and recovery mechanisms
- **6.5**: Comprehensive error logging for debugging and monitoring

The system provides a solid foundation for all error scenarios throughout the application while maintaining consistency and good user experience.