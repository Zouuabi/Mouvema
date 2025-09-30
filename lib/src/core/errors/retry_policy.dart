/// Retry policy configuration for error recovery
class RetryPolicy {
  final int maxAttempts;
  final Duration initialDelay;
  final double backoffMultiplier;
  final Duration maxDelay;
  final List<String> retryableErrorCodes;

  const RetryPolicy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.maxDelay = const Duration(seconds: 30),
    this.retryableErrorCodes = const [],
  });

  /// Default retry policy for network operations
  static const RetryPolicy network = RetryPolicy(
    maxAttempts: 3,
    initialDelay: Duration(seconds: 1),
    backoffMultiplier: 2.0,
    maxDelay: Duration(seconds: 10),
    retryableErrorCodes: [
      'NETWORK_TIMEOUT',
      'NETWORK_SERVER_UNAVAILABLE',
      'NETWORK_INTERNAL_ERROR',
    ],
  );

  /// Default retry policy for authentication operations
  static const RetryPolicy auth = RetryPolicy(
    maxAttempts: 2,
    initialDelay: Duration(milliseconds: 500),
    backoffMultiplier: 1.5,
    maxDelay: Duration(seconds: 5),
    retryableErrorCodes: [
      'AUTH_NETWORK_ERROR',
      'AUTH_SERVER_ERROR',
      'AUTH_TOO_MANY_REQUESTS',
    ],
  );

  /// Default retry policy for geocoding operations
  static const RetryPolicy geocoding = RetryPolicy(
    maxAttempts: 2,
    initialDelay: Duration(milliseconds: 800),
    backoffMultiplier: 1.8,
    maxDelay: Duration(seconds: 8),
    retryableErrorCodes: [
      'MAP_GEOCODING_FAILED',
      'MAP_LOADING_FAILED',
      'NETWORK_TIMEOUT',
    ],
  );

  /// Calculates the delay for a given attempt number
  Duration getDelayForAttempt(int attemptNumber) {
    if (attemptNumber <= 0) return Duration.zero;
    
    final delay = initialDelay * 
        (backoffMultiplier * (attemptNumber - 1));
    
    return delay > maxDelay ? maxDelay : delay;
  }

  /// Checks if an error code is retryable according to this policy
  bool isRetryable(String errorCode) {
    return retryableErrorCodes.contains(errorCode);
  }

  /// Creates a copy of this policy with updated values
  RetryPolicy copyWith({
    int? maxAttempts,
    Duration? initialDelay,
    double? backoffMultiplier,
    Duration? maxDelay,
    List<String>? retryableErrorCodes,
  }) {
    return RetryPolicy(
      maxAttempts: maxAttempts ?? this.maxAttempts,
      initialDelay: initialDelay ?? this.initialDelay,
      backoffMultiplier: backoffMultiplier ?? this.backoffMultiplier,
      maxDelay: maxDelay ?? this.maxDelay,
      retryableErrorCodes: retryableErrorCodes ?? this.retryableErrorCodes,
    );
  }
}