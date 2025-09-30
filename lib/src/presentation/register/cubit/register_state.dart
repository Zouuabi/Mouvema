part of 'register_cubit.dart';

enum Status { initial, loading, registerSuccess, registerFailed, validationError }

class RegisterState extends Equatable {
  const RegisterState({
    required this.status,
    this.errorMessage,
    this.authError,
    this.emailError,
    this.passwordError,
    this.passwordStrength = PasswordStrength.empty,
  });

  final Status status;
  final String? errorMessage;
  final AuthError? authError;
  final AuthError? emailError;
  final AuthError? passwordError;
  final PasswordStrength passwordStrength;

  bool get hasEmailError => emailError != null;
  bool get hasPasswordError => passwordError != null;
  bool get hasValidationErrors => hasEmailError || hasPasswordError;

  RegisterState copyWith({
    Status? status,
    String? errorMessage,
    AuthError? authError,
    AuthError? emailError,
    AuthError? passwordError,
    PasswordStrength? passwordStrength,
    bool clearErrors = false,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      authError: clearErrors ? null : (authError ?? this.authError),
      emailError: clearErrors ? null : (emailError ?? this.emailError),
      passwordError: clearErrors ? null : (passwordError ?? this.passwordError),
      passwordStrength: passwordStrength ?? this.passwordStrength,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, authError, emailError, passwordError, passwordStrength];
}
