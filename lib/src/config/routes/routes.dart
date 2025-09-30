import 'package:flutter/material.dart';

import '../../data/models/load.dart';
import '../../injector.dart';
import '../../presentation/forgot_password/pages/forgot_password_screen.dart';
import '../../presentation/login/pages/login_screen.dart';

import '../../presentation/main/fill_profil/pages/fill_profile_screen.dart';
import '../../presentation/main/load_details/load_details_screen.dart';
import '../../presentation/main/main_screen.dart';
import '../../presentation/main/post_load/pages/post_load_screen.dart';
import '../../presentation/main/profile/pages/profile_screen.dart';
import '../../presentation/register/pages/register_screen.dart';

class Routes {
  static const String splash = "/";
  static const String login = "/login";

  static const String register = "/register";
  static const String forgotPassword = "/forgortPassword";

  static const String main = "/main";
  static const String loadDetails = "/loadDetails";
  static const String postLoad = "/postLoad";
  static const String fillProfil = "/fillProfil";
  static const String profil = "/Profil";
  static const String mapScreen = "/mapScreen";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      // login screen
      case Routes.login:
        loginInstances();
        return MaterialPageRoute(builder: (BuildContext ctx) {
          return const LoginScreen();
        });

      // main screen
      case Routes.main:
        homeInstances();

        return MaterialPageRoute(builder: (BuildContext ctx) {
          return const MainScreen();
        });
      // forgot password
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (BuildContext ctx) {
          return const ForgotPasswordScreen();
        });

      // **************************
      case Routes.fillProfil:
        fillProfileInstances();
        return MaterialPageRoute(builder: (BuildContext ctx) {
          return const FillProfileScreen();
        });
      case Routes.profil:
        return MaterialPageRoute(builder: (BuildContext ctx) {
          return const ProfileScreen();
        });

      //************************* */

      case Routes.register:
        registerInstances();
        return MaterialPageRoute(builder: (BuildContext ctx) {
          return const RegisterScreen();
        });

      //************************** */

      case Routes.loadDetails:
        return MaterialPageRoute(builder: (BuildContext ctx) {
          final Load arg = settings.arguments as Load;
          return LoadDetailsScreen(load: arg);
        });

      //************************** */

      //************************** */
      case Routes.postLoad:
        postInstances();
        return MaterialPageRoute(builder: (BuildContext ctx) {
          return PostLoadScreen();
        });
      default:
        // naamlou page 404
        return MaterialPageRoute(builder: (ctx) {
          return const Placeholder(
            child: Text('404 Not Found'),
          );
        });
    }
  }
}
