import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/helpers/email_checker.dart';
import '../../../core/errors/auth_error.dart';
import '../../../core/errors/error_types.dart';
import '../../../data/repository/repository_impl.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._repository)
      : super(const ForgotPasswordState(status: Status.initial));

  final RepositoryImpl _repository;
  final TextEditingController emailController = TextEditingController();

  AuthError? emailError;

  void onFieldChanged() {
    // Clear errors when user starts typing
    if (emailError != null) {
      clearEmailError();
    }
  }

  void clearEmailError() {
    emailError = null;
    emit(state.copyWith(emailError: null));
  }

  void validateEmailField() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      emailError = AuthError.validation(
        field: 'email',
        validationType: ValidationErrorType.required,
        customMessage: 'Email is required',
      );
    } else if (!isValidEmail(email)) {
      emailError = AuthError.validation(
        field: 'email',
        validationType: ValidationErrorType.invalidFormat,
        customMessage: 'Please enter a valid email address',
      );
    } else {
      emailError = null;
    }

    emit(state.copyWith(emailError: emailError));
  }

  void sendPasswordResetEmail({required String email}) async {
    // Validate email first
    validateEmailField();

    if (emailError != null) {
      return;
    }

    emit(state.copyWith(status: Status.loading));

    var result = await _repository.sendPasswordResetEmail(email: email);

    result.fold(
        (l) => emit(state.copyWith(
            status: Status.failed, errorMessage: l.errrorMessage)),
        (r) => emit(state.copyWith(status: Status.emailSent)));
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}
