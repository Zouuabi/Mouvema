part of 'register_cubit.dart';

enum Status {
  initial,
  loading,
  registerSuccess,
  registerFailed,
  validationError
}

class RegisterState extends Equatable {
  const RegisterState({
    required this.status,
    this.errorMessage,
    this.authError,
    this.emailError,
    this.passwordError,
    this.usernameError,
    this.birthDateError,
    this.userTypeError,
    this.passwordStrength = PasswordStrength.empty,
  });

  final Status status;
  final String? errorMessage;
  final AuthError? authError;
  final AuthError? emailError;
  final AuthError? passwordError;
  final AuthError? usernameError;
  final AuthError? birthDateError;
  final AuthError? userTypeError;
  final PasswordStrength passwordStrength;

  bool get hasEmailError => emailError != null;
  bool get hasPasswordError => passwordError != null;
  bool get hasUsernameError => usernameError != null;
  bool get hasBirthDateError => birthDateError != null;
  bool get hasUserTypeError => userTypeError != null;
  bool get hasValidationErrors =>
      hasEmailError ||
      hasPasswordError ||
      hasUsernameError ||
      hasBirthDateError ||
      hasUserTypeError;

  RegisterState copyWith({
    Status? status,
    String? errorMessage,
    AuthError? authError,
    AuthError? emailError,
    AuthError? passwordError,
    AuthError? usernameError,
    AuthError? birthDateError,
    AuthError? userTypeError,
    PasswordStrength? passwordStrength,
    bool clearErrors = false,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      authError: clearErrors ? null : authError ?? this.authError,
      emailError: emailError,
      passwordError: passwordError,
      usernameError: usernameError,
      birthDateError: birthDateError,
      userTypeError: userTypeError,
      passwordStrength: passwordStrength ?? this.passwordStrength,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        authError,
        emailError,
        passwordError,
        usernameError,
        birthDateError,
        userTypeError,
        passwordStrength
      ];
}
