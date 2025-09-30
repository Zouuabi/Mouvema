import 'dart:typed_data';
import 'package:flutter/material.dart' show TextEditingController;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/errors/errors.dart';
import '../../../data/repository/repository_impl.dart';
import '../../../data/models/user.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._repositoryImpl)
      : super(const RegisterState(status: Status.initial));

  final RepositoryImpl _repositoryImpl;

  // Text controllers for all form fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Additional form state
  DateTime? _selectedBirthDate;
  UserType? _selectedUserType;
  Uint8List? _selectedImage;

  // Getters for form state
  DateTime? get selectedBirthDate => _selectedBirthDate;
  UserType? get selectedUserType => _selectedUserType;
  Uint8List? get selectedImage => _selectedImage;

  /// Validates email field and returns error if invalid
  AuthError? _validateEmail(String email) {
    return EmailValidator.validate(email);
  }

  /// Validates password field and returns error if invalid
  AuthError? _validatePassword(String password) {
    return PasswordValidator.validate(password);
  }

  /// Validates username field and returns error if invalid
  AuthError? _validateUsername(String username) {
    if (username.trim().isEmpty) {
      return AuthError.validation(
        field: 'username',
        validationType: ValidationErrorType.required,
        customMessage: 'Username is required',
      );
    }
    if (username.trim().length < 2) {
      return AuthError.validation(
        field: 'username',
        validationType: ValidationErrorType.tooShort,
        customMessage: 'Username must be at least 2 characters',
      );
    }
    if (username.trim().length > 30) {
      return AuthError.validation(
        field: 'username',
        validationType: ValidationErrorType.tooLong,
        customMessage: 'Username must be less than 30 characters',
      );
    }
    return null;
  }

  /// Validates phone field and returns error if invalid
  AuthError? _validatePhone(String phone) {
    // No validation for phone number as requested
    return null;
  }

  /// Validates birth date and returns error if invalid
  AuthError? _validateBirthDate(DateTime? birthDate) {
    if (birthDate == null) {
      return AuthError.validation(
        field: 'birthDate',
        validationType: ValidationErrorType.required,
        customMessage: 'Date of birth is required',
      );
    }
    
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    
    if (age < 18) {
      return AuthError.validation(
        field: 'birthDate',
        validationType: ValidationErrorType.invalidRange,
        customMessage: 'You must be at least 18 years old',
      );
    }
    
    if (age > 100) {
      return AuthError.validation(
        field: 'birthDate',
        validationType: ValidationErrorType.invalidRange,
        customMessage: 'Please enter a valid birth date',
      );
    }
    
    return null;
  }

  /// Validates user type and returns error if invalid
  AuthError? _validateUserType(UserType? userType) {
    if (userType == null) {
      return AuthError.validation(
        field: 'userType',
        validationType: ValidationErrorType.required,
        customMessage: 'Please select your user type',
      );
    }
    return null;
  }

  /// Validates all fields and emits validation errors if any
  bool _validateFields() {
    final emailError = _validateEmail(emailController.text);
    final passwordError = _validatePassword(passwordController.text);
    final usernameError = _validateUsername(usernameController.text);
    final phoneError = _validatePhone(phoneController.text);
    final birthDateError = _validateBirthDate(_selectedBirthDate);
    final userTypeError = _validateUserType(_selectedUserType);

    if (emailError != null || 
        passwordError != null || 
        usernameError != null || 
        phoneError != null || 
        birthDateError != null || 
        userTypeError != null) {
      emit(RegisterState(
        status: Status.validationError,
        emailError: emailError,
        passwordError: passwordError,
        usernameError: usernameError,
        phoneError: phoneError,
        birthDateError: birthDateError,
        userTypeError: userTypeError,
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

  /// Real-time username validation
  void validateUsernameField() {
    final usernameError = _validateUsername(usernameController.text);
    if (usernameError != state.usernameError) {
      emit(state.copyWith(usernameError: usernameError));
    }
  }

  /// Real-time phone validation
  void validatePhoneField() {
    final phoneError = _validatePhone(phoneController.text);
    if (phoneError != state.phoneError) {
      emit(state.copyWith(phoneError: phoneError));
    }
  }

  /// Clears field-specific errors when user starts typing
  void clearFieldError(String field) {
    switch (field) {
      case 'email':
        if (state.hasEmailError) {
          emit(state.copyWith(emailError: null));
        }
        break;
      case 'password':
        if (state.hasPasswordError) {
          emit(state.copyWith(passwordError: null));
        }
        break;
      case 'username':
        if (state.hasUsernameError) {
          emit(state.copyWith(usernameError: null));
        }
        break;
      case 'phone':
        if (state.hasPhoneError) {
          emit(state.copyWith(phoneError: null));
        }
        break;
      case 'birthDate':
        if (state.hasBirthDateError) {
          emit(state.copyWith(birthDateError: null));
        }
        break;
      case 'userType':
        if (state.hasUserTypeError) {
          emit(state.copyWith(userTypeError: null));
        }
        break;
    }
  }

  /// Updates the selected birth date
  void updateBirthDate(DateTime birthDate) {
    _selectedBirthDate = birthDate;
    final birthDateError = _validateBirthDate(birthDate);
    emit(state.copyWith(birthDateError: birthDateError));
  }

  /// Updates the selected user type
  void updateUserType(UserType userType) {
    _selectedUserType = userType;
    final userTypeError = _validateUserType(userType);
    emit(state.copyWith(userTypeError: userTypeError));
  }

  /// Updates the selected profile image
  void updateProfileImage(Uint8List? image) {
    _selectedImage = image;
    // Profile image is optional, so no validation needed
  }

  /// Synchronous validation methods for UI checks
  AuthError? validateUsernameSync(String username) {
    return _validateUsername(username);
  }

  AuthError? validateEmailSync(String email) {
    return _validateEmail(email);
  }

  AuthError? validatePasswordSync(String password) {
    return _validatePassword(password);
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
      // First, create the Firebase Auth account
      var authResult = await _repositoryImpl.register(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await authResult.fold(
        (failure) async {
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
        (success) async {
          // Auth account created successfully, now save user profile
          try {
            final profileResult = await _repositoryImpl.fillProfil(
              username: usernameController.text.trim(),
              birthdate: _formatDate(_selectedBirthDate!),
              tel: phoneController.text.trim(),
              userType: _selectedUserType!.name,
              image: _selectedImage,
            );

            profileResult.fold(
              (failure) {
                final authError = AuthError(
                  type: AuthErrorType.serverError,
                  userMessage: 'Account created but profile setup failed. Please complete your profile later.',
                );
                emit(RegisterState(
                  status: Status.registerFailed,
                  authError: authError,
                  errorMessage: authError.userMessage,
                ));
              },
              (success) {
                emit(const RegisterState(status: Status.registerSuccess));
              },
            );
          } catch (e) {
            final authError = AuthError(
              type: AuthErrorType.serverError,
              userMessage: 'Account created but profile setup failed. Please complete your profile later.',
              technicalMessage: e.toString(),
            );
            emit(RegisterState(
              status: Status.registerFailed,
              authError: authError,
              errorMessage: authError.userMessage,
            ));
          }
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

  /// Formats date for storage
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    return super.close();
  }
}
