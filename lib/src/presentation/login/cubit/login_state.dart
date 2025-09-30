part of 'login_cubit.dart';

enum Status { initial, loading, success, failed, validationError }

class LoginScreenState extends Equatable {
  const LoginScreenState({
    required this.status,
    this.errorMessage,
    this.data,
    this.authError,
    this.emailError,
    this.passwordError,
  });

  final Status status;
  final String? errorMessage;
  final String? data;
  final AuthError? authError;
  final AuthError? emailError;
  final AuthError? passwordError;

  bool get hasEmailError => emailError != null;
  bool get hasPasswordError => passwordError != null;
  bool get hasValidationErrors => hasEmailError || hasPasswordError;

  LoginScreenState copyWith({
    Status? status,
    String? errorMessage,
    String? data,
    AuthError? authError,
    AuthError? emailError,
    AuthError? passwordError,
    bool clearErrors = false,
  }) {
    return LoginScreenState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
      authError: clearErrors ? null : (authError ?? this.authError),
      emailError: clearErrors ? null : (emailError ?? this.emailError),
      passwordError: clearErrors ? null : (passwordError ?? this.passwordError),
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, data, authError, emailError, passwordError];
}
