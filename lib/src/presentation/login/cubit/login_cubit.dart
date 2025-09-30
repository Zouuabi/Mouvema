import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/failure.dart';
import '../../../core/errors/errors.dart';
import '../../../data/repository/repository_impl.dart';
part 'login_state.dart';

class LoginScreenCubit extends Cubit<LoginScreenState> {
  LoginScreenCubit(this.repositoryImpl)
      : super(const LoginScreenState(status: Status.initial));
  RepositoryImpl repositoryImpl;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

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
    final emailError = _validateEmail(_emailController.text);
    final passwordError = _validatePassword(_passwordController.text);

    if (emailError != null || passwordError != null) {
      emit(LoginScreenState(
        status: Status.validationError,
        emailError: emailError,
        passwordError: passwordError,
      ));
      return false;
    }

    return true;
  }

  /// Clears field-specific errors when user starts typing
  void clearFieldError(String field) {
    if (field == 'email' && state.hasEmailError) {
      emit(state.copyWith(emailError: null));
    } else if (field == 'password' && state.hasPasswordError) {
      emit(state.copyWith(passwordError: null));
    }
  }

  /// Validates email field on focus loss (less aggressive)
  void validateEmailField() {
    final emailError = _validateEmail(_emailController.text);
    if (emailError != state.emailError) {
      emit(state.copyWith(emailError: emailError));
    }
  }

  /// Validates password field on focus loss (less aggressive)
  void validatePasswordField() {
    final passwordError = _validatePassword(_passwordController.text);
    if (passwordError != state.passwordError) {
      emit(state.copyWith(passwordError: passwordError));
    }
  }

  /// Called when user is typing - only clears errors, doesn't show new ones
  void onFieldChanged(String field) {
    if (field == 'email' && state.hasEmailError) {
      emit(state.copyWith(emailError: null));
    } else if (field == 'password' && state.hasPasswordError) {
      emit(state.copyWith(passwordError: null));
    }
  }

  void logIn() async {
    // Clear any previous errors
    emit(state.copyWith(clearErrors: true));

    // Validate fields
    if (!_validateFields()) {
      return;
    }

    emit(const LoginScreenState(status: Status.loading));

    try {
      Either<Failure, void> result = await repositoryImpl.signIn(
          _emailController.text, _passwordController.text);

      result.fold(
        (failure) {
          // Map Firebase error codes to proper AuthError
          AuthError authError;
          final errorCode = failure.errrorMessage;
          
          // Create a proper FirebaseAuthException for mapping
          final firebaseException = FirebaseAuthException(
            code: errorCode,
            message: failure.errrorMessage,
          );
          
          authError = AuthError.fromFirebaseException(firebaseException);

          emit(LoginScreenState(
            status: Status.failed,
            authError: authError,
            errorMessage: authError.userMessage,
          ));
        },
        (complete) async {
          emit(const LoginScreenState(status: Status.success));
        },
      );
    } catch (e) {
      // Handle unexpected errors
      final authError = AuthError(
        type: AuthErrorType.serverError,
        userMessage: 'An unexpected error occurred. Please try again.',
        technicalMessage: e.toString(),
      );

      emit(LoginScreenState(
        status: Status.failed,
        authError: authError,
        errorMessage: authError.userMessage,
      ));
    }
  }

  @override
  Future<void> close() {
    _emailController.dispose();
    _passwordController.dispose();
    return super.close();
  }
}
