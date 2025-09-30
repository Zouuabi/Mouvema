import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouvema/src/config/routes/routes.dart';
import 'package:mouvema/src/core/utils/string_manager.dart';

import '../../../core/errors/auth_error.dart';
import '../../../data/repository/repository_impl.dart';
import '../../../injector.dart';
import '../../shared/enhanced_text_field.dart';
import '../../shared/loading_button.dart';
import '../../shared/password_strength_indicator.dart';
import '../cubit/register_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
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
    return BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(instance<RepositoryImpl>()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Create Account',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state.status == Status.registerSuccess) {
                  _showSuccessDialog(context);
                } else if (state.status == Status.registerFailed && state.authError != null) {
                  _showErrorDialog(context, state.authError!);
                }
              },
              builder: (context, state) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _registerContent(context, state),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerContent(BuildContext context, RegisterState state) {
    final cubit = BlocProvider.of<RegisterCubit>(context);
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
                      Icons.person_add_rounded,
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
                          'Create your\nAccount',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Join us today! Please fill in your details.',
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
          flex: 5,
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Form header
                      Text(
                        'Sign Up',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your account to get started',
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

                      // Password strength indicator with enhanced styling
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: PasswordStrengthIndicator(
                          strength: state.passwordStrength,
                          password: cubit.passwordController.text,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Register button with enhanced styling
                      LoadingButton(
                        onPressed: () => cubit.register(),
                        text: StringManager.signUp,
                        isLoading: state.status == Status.loading,
                        height: 56,
                        icon: const Icon(Icons.person_add_rounded),
                      ),
                    ],
                  ),
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
                    StringManager.alreadyHaveAccount,
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      StringManager.singIn,
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Welcome to Mouvema!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Your account has been created successfully! You can now sign in with your credentials and start managing your loads.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            FilledButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.loginWithPassword);
              },
              icon: const Icon(Icons.login_rounded),
              label: const Text('Sign In Now'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        );
      },
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
                  'Registration Failed',
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

//   Column _getForm(
//       RegisterCubit mycubit, RegisterState state, BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         MyTextField(
//           labelText: 'username',
//           errorMessage: 'username is required',
//           keyboardType: TextInputType.name,
//           icon: null,
//           controller: mycubit.usernameController,
//           hintText: 'Enter your username',
//           isError:
//               state is RegisterError && state.errorMessage == 'username empty'
//                   ? true
//                   : false,
//         ),
//         const SizedBox(height: 20),
//         DateWidget(
//           isError: state is RegisterError && state.errorMessage == 'date empty'
//               ? true
//               : false,
//           label: state is RegisterDateAdded
//               ? state.date.substring(0, 9)
//               : mycubit.birth,
//           onPressed: () {
//             pickDate(context).then((date) {
//               mycubit.dateAdded(date.toString());
//             });
//           },
//         ),
//         const SizedBox(height: 20),
//         MyTextField(
//           labelText: 'email',
//           errorMessage: 'email is required',
//           keyboardType: TextInputType.name,
//           icon: null,
//           controller: mycubit.emailController,
//           hintText: 'user@example.com',
//           isError: state is RegisterError && state.errorMessage == 'email empty'
//               ? true
//               : false,
//         ),
//         const SizedBox(height: 20),
//         MyTextField(
//           isPassword: true,
//           labelText: 'password',
//           errorMessage: 'password is required',
//           keyboardType: TextInputType.name,
//           icon: null,
//           controller: mycubit.passwordController,
//           hintText: 'Enter your password',
//           isError: ((state is RegisterError) &&
//                   state.errorMessage == 'password empty')
//               ? true
//               : false,
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//             onPressed: () {
//               mycubit.register();
//             },
//             child: const Text('Register')),
//       ],
//     );
//   }
}
