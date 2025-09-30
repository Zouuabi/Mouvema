import 'package:flutter/material.dart' show TextEditingController;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/errors/errors.dart';
import '../../../data/repository/repository_impl.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._repositoryImpl)
      : super(const RegisterState(status: Status.initial));

  final RepositoryImpl _repositoryImpl;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// Validates email field and returns error if invalid
  AuthError? _validateEmail(String email) {
    return EmailValidator.validate(email);
  }

  /// Validates password field and returns error if invalid
  AuthError? _validatePassword(String password) {
    return PasswordValidator.validate(password);
  }

  /// Validates all fields and emits validation errors if any
  bool _validateFields() {
    final emailError = _validateEmail(emailController.text);
    final passwordError = _validatePassword(passwordController.text);

    if (emailError != null || passwordError != null) {
      emit(RegisterState(
        status: Status.validationError,
        emailError: emailError,
        passwordError: passwordError,
        passwordStrength: PasswordValidator.getStrength(passwordController.text),
      ));
      return false;
    }

    return true;
  }

  /// Real-time email validation
  void validateEmailField() {
    final emailError = _validateEmail(emailController.text);
    if (emailError != state.emailError) {
      emit(state.copyWith(emailError: emailError));
    }
  }

  /// Real-time password validation and strength calculation
  void validatePasswordField() {
    final passwordError = _validatePassword(passwordController.text);
    final passwordStrength = PasswordValidator.getStrength(passwordController.text);
    
    if (passwordError != state.passwordError || passwordStrength != state.passwordStrength) {
      emit(state.copyWith(
        passwordError: passwordError,
        passwordStrength: passwordStrength,
      ));
    }
  }

  /// Clears field-specific errors when user starts typing
  void clearFieldError(String field) {
    if (field == 'email' && state.hasEmailError) {
      emit(state.copyWith(emailError: null));
    } else if (field == 'password' && state.hasPasswordError) {
      emit(state.copyWith(passwordError: null));
    }
  }

  void register() async {
    // Clear any previous errors
    emit(state.copyWith(clearErrors: true));

    // Validate fields
    if (!_validateFields()) {
      return;
    }

    emit(const RegisterState(status: Status.loading));

    try {
      var result = await _repositoryImpl.register(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      result.fold(
        (failure) {
          // Try to parse Firebase Auth error
          AuthError authError;
          try {
            // Check if it's a Firebase Auth error code
            final firebaseException = FirebaseAuthException(
              code: failure.errrorMessage ?? 'unknown',
              message: failure.errrorMessage,
            );
            authError = AuthError.fromFirebaseException(firebaseException);
          } catch (e) {
            // Fallback to generic error
            authError = AuthError(
              type: AuthErrorType.serverError,
              userMessage: failure.errrorMessage ?? 'An error occurred during registration',
            );
          }

          emit(RegisterState(
            status: Status.registerFailed,
            authError: authError,
            errorMessage: authError.userMessage,
          ));
        },
        (vd) {
          emit(const RegisterState(status: Status.registerSuccess));
        },
      );
    } catch (e) {
      // Handle unexpected errors
      final authError = AuthError(
        type: AuthErrorType.serverError,
        userMessage: 'An unexpected error occurred. Please try again.',
        technicalMessage: e.toString(),
      );

      emit(RegisterState(
        status: Status.registerFailed,
        authError: authError,
        errorMessage: authError.userMessage,
      ));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
