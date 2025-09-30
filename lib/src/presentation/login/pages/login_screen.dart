import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/routes/routes.dart';
import '../../../core/utils/image_manager.dart';
import '../../../core/errors/auth_error.dart';
import '../../../injector.dart';
import '../../shared/loading_button.dart';
import '../../shared/enhanced_text_field.dart';
import '../cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<LoginScreenCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<LoginScreenCubit, LoginScreenState>(
              listener: (context, state) {
                if (state.status == Status.failed && state.authError != null) {
                  _showErrorDialog(context, state.authError!);
                } else if (state.status == Status.success) {
                  _showSuccessAnimation(context);
                }
              },
              builder: (context, state) {
                final cubit = BlocProvider.of<LoginScreenCubit>(context);
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
                      
                      // Welcome text
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to your account',
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
                        error: state.emailError,
                        onChanged: () => cubit.validateEmailField(),
                        onClearError: () => cubit.clearFieldError('email'),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Password field
                      EnhancedTextField(
                        controller: cubit.passwordController,
                        hintText: 'Enter your password',
                        labelText: 'Password',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        error: state.passwordError,
                        onChanged: () => cubit.validatePasswordField(),
                        onClearError: () => cubit.clearFieldError('password'),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.forgotPassword);
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Sign in button
                      SizedBox(
                        width: double.infinity,
                        child: LoadingButton(
                          onPressed: () => cubit.logIn(),
                          text: 'Sign In',
                          isLoading: state.status == Status.loading,
                          height: 56,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Sign up link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 16,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.register);
                              },
                              child: Text(
                                'Sign Up',
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

  void _showErrorDialog(BuildContext context, AuthError error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Error'),
          content: Text(error.userMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessAnimation(BuildContext context) {
    

   
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, Routes.main);
      }
    }
  
}
