import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mouvema/src/core/utils/image_manager.dart';
import 'package:mouvema/src/presentation/main/on_boarding/pages/on_boarding.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleController.forward();
    });

    // Navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Top section with logo - takes up upper portion
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Image.asset(
                          ImageManager.logoWithName,
                          height: screenHeight * 0.15, // Responsive sizing
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // Bottom section with text and loading - in white space
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Welcome text with app's font family and proper styling
                          Text(
                            'Welcome to Mouvema',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontFamily: 'Inter',
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          // Subtitle with consistent font family
                          Text(
                            'Your trusted partner for shipping and delivery',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.5,
                              letterSpacing: 0.1,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 48),

                          // Loading indicator with brand color
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom padding
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
