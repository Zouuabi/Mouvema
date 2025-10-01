part of 'forgot_password_cubit.dart';

enum Status { initial, loading, emailSent, failed }

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    required this.status,
    this.errorMessage,
    this.data,
    this.emailError,
  });

  final Status status;
  final String? errorMessage;
  final String? data;
  final AuthError? emailError;

  ForgotPasswordState copyWith({
    Status? status,
    String? errorMessage,
    String? data,
    AuthError? emailError,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
      emailError: emailError,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, data, emailError];
}
