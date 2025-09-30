import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouvema/src/core/utils/string_manager.dart';
import '../../../config/routes/routes.dart';
import '../../../core/utils/image_manager.dart';
import '../../../core/errors/auth_error.dart';
import '../../../injector.dart';
import '../../shared/loading_button.dart';
import '../cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<LoginScreenCubit, LoginScreenState>(
              listener: (context, state) {
                if (state.status == Status.failed && state.authError != null) {
                  _showErrorDialog(context, state.authError!);
                } else if (state.status == Status.success) {
                  _showSuccessAnimation(context);
                }
              },
              builder: (context, state) {
                return _buildContent(context, state);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LoginScreenState state) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Logo section with fade animation
        Expanded(
          flex: 3,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'app_logo',
                  child: Image.asset(
                    ImageManager.logoWithName,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to Mouvema',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your trusted logistics partner',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Main action card with slide animation
        Expanded(
          flex: 4,
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Card(
                elevation: 8,
                shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.login_rounded,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Sign In',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Access your account to manage loads and connect with drivers',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      LoadingButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.loginWithPassword);
                        },
                        text: StringManager.signInWithPaswword,
                        isLoading: state.status == Status.loading,
                        height: 56,
                        icon: const Icon(Icons.email_outlined),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Footer section with fade animation
        Expanded(
          flex: 2,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringManager.dontHaveAccount,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.register);
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
                const SizedBox(height: 16),
                Text(
                  '© 2024 Mouvema. All rights reserved.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
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
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(error.severity.icon, color: error.severity.color, size: 28),
              const SizedBox(width: 12),
              const Text('Authentication Error'),
            ],
          ),
          content: Text(error.userMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(error.isRetryable ? 'Try Again' : 'OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessAnimation(BuildContext context) {
    // Show a brief success indicator before navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Login successful!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 1500),
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
