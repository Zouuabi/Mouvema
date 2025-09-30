import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouvema/src/core/utils/string_manager.dart';

import '../../../config/routes/routes.dart';
import '../../../core/errors/auth_error.dart';
import '../../../injector.dart';
import '../../shared/enhanced_text_field.dart';
import '../../shared/loading_button.dart';
import '../cubit/login_cubit.dart';

class LoginWithPassword extends StatefulWidget {
  const LoginWithPassword({super.key});

  @override
  State<LoginWithPassword> createState() => _LoginWithPasswordState();
}

class _LoginWithPasswordState extends State<LoginWithPassword>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<LoginScreenCubit>(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<LoginScreenCubit, LoginScreenState>(
              builder: (context, state) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _screenContent(context, state),
                  ),
                );
              },
              listener: (context, state) {
                if (state.status == Status.failed && state.authError != null) {
                  _showErrorDialog(context, state.authError!);
                } else if (state.status == Status.success) {
                  _showSuccessAnimation(context);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _screenContent(BuildContext context, LoginScreenState state) {
    final cubit = BlocProvider.of<LoginScreenCubit>(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header section with enhanced styling
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.login_rounded,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringManager.loginToYourAccount,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Welcome back! Please enter your credentials.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Form section with enhanced design
        Expanded(
          flex: 4,
          child: Card(
            elevation: 12,
            shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.surface,
                    theme.colorScheme.surface.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Form header
                    Text(
                      'Sign In',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your credentials to access your account',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Email field
                    EnhancedTextField(
                      controller: cubit.emailController,
                      hintText: 'user@example.com',
                      labelText: 'Email Address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      error: state.emailError,
                      onChanged: () => cubit.validateEmailField(),
                      onClearError: () => cubit.clearFieldError('email'),
                    ),
                    const SizedBox(height: 24),

                    // Password field
                    EnhancedTextField(
                      controller: cubit.passwordController,
                      hintText: StringManager.enterYourPassword,
                      labelText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      error: state.passwordError,
                      onChanged: () => cubit.validatePasswordField(),
                      onClearError: () => cubit.clearFieldError('password'),
                    ),
                    const SizedBox(height: 16),

                    // Forgot password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.forgotPassword);
                        },
                        icon: const Icon(Icons.help_outline, size: 16),
                        label: Text(
                          StringManager.forgotPassword,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Login button with enhanced styling
                    LoadingButton(
                      onPressed: () => cubit.logIn(),
                      text: StringManager.singIn,
                      isLoading: state.status == Status.loading,
                      height: 56,
                      icon: const Icon(Icons.login_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Footer section
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringManager.dontHaveAccount,
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      StringManager.signUp,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showErrorDialog(BuildContext context, AuthError error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
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
                  'Login Failed',
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
                error.isRetryable ? 'Try Again' : 'OK',
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

  void _showSuccessAnimation(BuildContext context) {
    // Show a brief success indicator before navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Login successful!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(milliseconds: 1500),
      ),
    );

    // Navigate after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, Routes.main);
      }
    });
  }
}
