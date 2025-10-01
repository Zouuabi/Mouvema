import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouvema/src/config/routes/routes.dart';
import 'package:mouvema/src/presentation/shared/enhanced_text_field.dart';
import 'package:mouvema/src/presentation/shared/password_strength_indicator.dart';

import '../../../core/errors/auth_error.dart';
import '../../../data/repository/repository_impl.dart';
import '../../../data/models/user.dart';
import '../../../injector.dart';
import '../../shared/loading_button.dart';
import '../widgets/register_text_field.dart';
import '../cubit/register_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late PageController _pageController;
  int _currentStep = 0;
  final int _totalSteps = 4; // Reduced from 5 to 4 (removed phone step)

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(instance<RepositoryImpl>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 0, // Hide the default app bar
        ),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state.status == Status.registerSuccess) {
              _showSuccessDialog(context);
            } else if (state.status == Status.registerFailed &&
                state.authError != null) {
              _showErrorDialog(context, state.authError!);
            }
          },
          builder: (context, state) {
            final cubit = BlocProvider.of<RegisterCubit>(context);
            return Column(
              children: [
                // App bar with next button
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.black),
                        onPressed: () => _handleBackPress(context),
                      ),
                      if (_currentStep < _totalSteps - 1)
                        TextButton(
                          onPressed: _canProceedToNextStep(cubit, state)
                              ? () => _nextStep(cubit)
                              : null,
                          child: Text(
                            'Next',
                            style: TextStyle(
                              color: _canProceedToNextStep(cubit, state)
                                  ? Colors.teal
                                  : Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Progress indicator
                Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    value: (_currentStep + 1) / _totalSteps,
                    backgroundColor: Colors.grey.shade200,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                ),

                // Content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildUserTypeStep(context, state),
                      _buildNameStep(context, state),
                      _buildBirthdayStep(context, state),
                      _buildPasswordStep(context, state),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNameStep(BuildContext context, RegisterState state) {
    final cubit = BlocProvider.of<RegisterCubit>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text(
            'My name',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40),

          // Username input
          EnhancedTextField(
            controller: cubit.usernameController,
            hintText: 'Enter your username',
            labelText: 'Username',
            prefixIcon: Icons.person_outline,
            error: state.usernameError,
            onChanged: () => cubit.validateUsernameField(),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthdayStep(BuildContext context, RegisterState state) {
    final cubit = BlocProvider.of<RegisterCubit>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text(
            'My birthday',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your age will be public',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 40),

          // Date input
          GestureDetector(
            onTap: () => _selectDate(context, cubit),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      cubit.selectedBirthDate != null
                          ? _formatDate(cubit.selectedBirthDate!)
                          : 'DD / MM / YYYY',
                      style: TextStyle(
                        fontSize: 16,
                        color: cubit.selectedBirthDate != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.grey),
                ],
              ),
            ),
          ),

          if (state.birthDateError != null) ...[
            const SizedBox(height: 8),
            Text(
              state.birthDateError!.userMessage,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserTypeStep(BuildContext context, RegisterState state) {
    final cubit = BlocProvider.of<RegisterCubit>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text(
            'I am a',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40),

          // User type options
          _buildUserTypeOption(
            'Shipper',
            'I need to ship goods',
            UserType.shipper,
            cubit.selectedUserType == UserType.shipper,
            () => cubit.updateUserType(UserType.shipper),
            cubit,
          ),
          const SizedBox(height: 16),
          _buildUserTypeOption(
            'Driver',
            'I transport goods',
            UserType.driver,
            cubit.selectedUserType == UserType.driver,
            () => cubit.updateUserType(UserType.driver),
            cubit,
          ),

          if (state.userTypeError != null) ...[
            const SizedBox(height: 16),
            Text(
              state.userTypeError!.userMessage,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserTypeOption(
    String title,
    String subtitle,
    UserType type,
    bool isSelected,
    VoidCallback onTap,
    RegisterCubit cubit,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.teal : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.teal,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordStep(BuildContext context, RegisterState state) {
    final cubit = BlocProvider.of<RegisterCubit>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Create account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),

            // Email input
            EnhancedTextField(
              controller: cubit.emailController,
              hintText: 'Enter your email',
              labelText: 'Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              error: state.emailError,
              // Real-time validation on every keystroke
              onChanged: () => cubit.validateEmailField(),
            ),

            const SizedBox(height: 16),

            // Password input
            EnhancedTextField(
              controller: cubit.passwordController,
              hintText: 'Enter your password',
              labelText: 'Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              error: state.passwordError,
              // Real-time validation and strength update on every keystroke
              onChanged: () => cubit.validatePasswordField(),
            ),

            PasswordStrengthIndicator(
              strength: state.passwordStrength,
              password: cubit.passwordController.text,
            ),
            const SizedBox(height: 40),
            // Register button
            BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, buttonState) {
                final isEnabled = _canCreateAccount(cubit, buttonState);
                return SizedBox(
                  width: double.infinity,
                  child: LoadingButton(
                    onPressed: isEnabled ? () => cubit.register() : null,
                    text: 'Create Account',
                    isLoading: buttonState.status == Status.loading,
                    height: 50,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceedToNextStep(RegisterCubit cubit, RegisterState state) {
    switch (_currentStep) {
      case 0: // User type step
        return cubit.selectedUserType != null;
      case 1: // Name step
        // Validate username and check if it's valid
        if (cubit.usernameController.text.isEmpty) return false;
        final usernameError =
            cubit.validateUsernameSync(cubit.usernameController.text);
        return usernameError == null;
      case 2: // Birthday step (was step 3, now step 2)
        return cubit.selectedBirthDate != null;
      case 3: // Password step (was step 4, now step 3)
        if (cubit.emailController.text.isEmpty ||
            cubit.passwordController.text.isEmpty) {
          return false;
        }
        // Check current state errors instead of validating again
        return state.emailError == null && state.passwordError == null;
      default:
        return false;
    }
  }

  bool _canCreateAccount(RegisterCubit cubit, RegisterState state) {
    // Check if all required fields are filled (removed phone requirement)
    final hasAllFields = cubit.usernameController.text.isNotEmpty &&
        cubit.selectedBirthDate != null &&
        cubit.selectedUserType != null &&
        cubit.emailController.text.isNotEmpty &&
        cubit.passwordController.text.isNotEmpty;

    // Check if there are no validation errors (removed phone error check)
    final hasNoErrors = state.usernameError == null &&
        state.birthDateError == null &&
        state.userTypeError == null &&
        state.emailError == null &&
        state.passwordError == null;

    final isNotLoading = state.status != Status.loading;

    return hasAllFields && hasNoErrors && isNotLoading;
  }

  void _nextStep(RegisterCubit cubit) {
    // Validate current step before proceeding
    bool canProceed = true;

    switch (_currentStep) {
      case 1: // Name step - validate username
        cubit.validateUsernameField();
        break;
      case 3: // Password step - validate email and password (was step 4, now step 3)
        cubit.validateEmailField();
        cubit.validatePasswordField();
        break;
    }

    if (canProceed && _currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });

      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleBackPress(BuildContext context) {
    if (_currentStep > 0) {
      _previousStep();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context, RegisterCubit cubit) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)),
    );

    if (picked != null) {
      cubit.updateBirthDate(picked);
      cubit.clearFieldError('birthDate');
      setState(() {});
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} / ${date.month.toString().padLeft(2, '0')} / ${date.year}';
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Welcome!'),
          content: const Text(
              'Your account has been created successfully. You are now logged in.'),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate directly to main screen since user is already logged in
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.main,
                  (route) => false,
                );
              },
              child: const Text('Continue'),
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
}
