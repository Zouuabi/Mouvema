import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/routes/routes.dart';
import '../../../core/utils/image_manager.dart';
import '../../../core/errors/auth_error.dart';
import '../../../core/errors/error_types.dart';
import '../../../data/repository/repository_impl.dart';
import '../../../injector.dart';
import '../../shared/enhanced_text_field.dart';
import '../../shared/loading_button.dart';
import '../cubit/forgot_password_cubit.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(instance<RepositoryImpl>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state.status == Status.failed && state.errorMessage != null) {
                _showErrorDialog(context, state.errorMessage!);
              } else if (state.status == Status.emailSent) {
                _showSuccessDialog(context);
              }
            },
            builder: (context, state) {
              final cubit = BlocProvider.of<ForgotPasswordCubit>(context);
              final theme = Theme.of(context);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Logo
                    Center(
                      child: Image.asset(
                        ImageManager.logoWithName,
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Reset password illustration
                    Center(
                      child: Image.asset(
                        ImageManager.forgortPassword,
                        height: 200,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Title and description
                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Don\'t worry! Enter your email address and we\'ll send you a link to reset your password.',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email field
                    EnhancedTextField(
                      controller: cubit.emailController,
                      hintText: 'Enter your email',
                      labelText: 'Email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      error: cubit.emailError,
                      onChanged: () => cubit.onFieldChanged(),
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) {
                          cubit.validateEmailField();
                        }
                      },
                      onClearError: () => cubit.clearEmailError(),
                    ),

                    const SizedBox(height: 32),

                    // Send reset email button
                    SizedBox(
                      width: double.infinity,
                      child: LoadingButton(
                        onPressed: () => cubit.sendPasswordResetEmail(
                          email: cubit.emailController.text.trim(),
                        ),
                        text: 'Send Reset Link',
                        isLoading: state.status == Status.loading,
                        height: 56,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Back to login link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Remember your password? ",
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, Routes.login);
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    final error = AuthError(
      type: AuthErrorType.networkError,
      userMessage: errorMessage,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: error.severity.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  error.severity.icon,
                  color: error.severity.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Reset Failed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Text(
            error.userMessage,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Try Again',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Email Sent',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: const Text(
            'We\'ve sent a password reset link to your email. Please check your inbox and follow the instructions.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, Routes.login);
              },
              child: Text(
                'Back to Login',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
