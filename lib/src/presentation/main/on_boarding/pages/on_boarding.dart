import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:mouvema/src/core/utils/color_manager.dart';

///Class to hold data for itembuilder in Withbuilder app.

import 'package:mouvema/src/presentation/login/pages/login_screen.dart';

class ItemData {
  final Color color;
  final String image;
  final String text1;

  ItemData(
    this.color,
    this.image,
    this.text1,
  );
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  int page = 0;
  late LiquidController liquidController;
  late UpdateType updateType;

  List<ItemData> data = [
    ItemData(
      Colors.teal,
      "assets/images/carousel1.jpg",
      "The best app for shipping and delivery services",
    ),
    ItemData(
      Colors.teal,
      "assets/images/carousel2.jpg",
      "Fast, reliable, and secure transportation solutions",
    ),
    ItemData(
      Colors.teal,
      "assets/images/carousel3.jpg",
      "Connect with trusted drivers and expand your business",
    ),
  ];

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return SizedBox(
      width: 25.0,
      child: Center(
        child: Material(
          color: ColorManager.mouvemaTeal,
          type: MaterialType.circle,
          child: SizedBox(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  void toLogin() async {
    Timer(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LiquidSwipe.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // Background image
                    Image.asset(
                      data[index].image,
                      fit: BoxFit.cover,
                    ),
                    // Gradient overlay for better text readability
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Color.fromRGBO(0, 0, 0, 0.3),
                            Color.fromRGBO(0, 0, 0, 0.6),
                          ],
                          stops: [0.0, 0.5, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            positionSlideIcon: 0.6,
            slideIconWidget: const Icon(
              Icons.arrow_back_ios,
              color: ColorManager.mouvemaWhite,
            ),
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            liquidController: liquidController,
            fullTransitionValue: 880,
            enableSideReveal: true,
            preferDragFromRevealedArea: true,
            enableLoop: true,
            ignoreUserGestureWhileAnimating: true,
          ),
          Positioned(
            bottom: 50,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(data.length, _buildDot),
            ),
          ),
          Positioned(
            bottom: 120,
            right: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: ColorManager.mouvemaWhite.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                data[page].text1,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.mouvemaBrown,
                      height: 1.4,
                      letterSpacing: -0.2,
                    ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextButton(
                onPressed: () {
                  liquidController.animateToPage(
                      page: data.length - 1, duration: 700);
                },
                style: TextButton.styleFrom(
                  backgroundColor:
                      ColorManager.mouvemaWhite.withValues(alpha: 0.9),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.mouvemaTeal,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextButton(
                onPressed: () {
                  liquidController.jumpToPage(
                      page: liquidController.currentPage + 1 > data.length - 1
                          ? 0
                          : liquidController.currentPage + 1);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        color: Colors.black54,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
    if (page == 2) {
      toLogin();
    }
  }
}
