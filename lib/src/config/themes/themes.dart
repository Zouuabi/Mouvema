import 'package:flutter/material.dart';

import '../../core/utils/color_manager.dart';

TextTheme _buildShrineTextTheme(TextTheme base, BuildContext context,
    {required bool light}) {
  // final textScaleFactor = MediaQuery.of(context).textScaleFactor;
  // final size = MediaQuery.of(context).size;

  Color white = Colors.white;

  return base
      .copyWith(
        displayLarge: base.displayLarge!.copyWith(
          fontWeight: FontWeight.w500,
        ),
        displayMedium: base.displayMedium!.copyWith(
          fontWeight: FontWeight.w500,
        ),
        displaySmall: base.displaySmall!.copyWith(
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: base.headlineLarge!.copyWith(),
        headlineMedium: base.headlineMedium!.copyWith(),
        headlineSmall: base.headlineSmall!.copyWith(),
        titleLarge: base.titleLarge!.copyWith(),
        titleMedium: base.titleMedium!.copyWith(),
        bodyLarge: base.bodyLarge!.copyWith(
          fontWeight: FontWeight.w500,
        ),
        bodySmall: base.bodySmall!.copyWith(
          fontWeight: FontWeight.w400,
        ),
        labelLarge: base.labelLarge!.copyWith(),
        labelMedium: base.labelMedium!.copyWith(),
        labelSmall: base.labelSmall!.copyWith(),
      )
      .apply(
        fontFamily: 'Inter',
        displayColor:
            light ? ColorManager.mouvemaBrown : ColorManager.mouvemaWhite,
        bodyColor:
            light ? ColorManager.mouvemaBrown : ColorManager.mouvemaWhite,
      );
}

ThemeData buildTheme({required BuildContext context, required bool light}) {
  final ThemeData baseLight = ThemeData.light(useMaterial3: true);
  final ThemeData baseDark = ThemeData.dark(useMaterial3: true);

  ThemeData lightMode = baseLight.copyWith(
    colorScheme: baseLight.colorScheme.copyWith(
      brightness: Brightness.light,
      primary: ColorManager.mouvemaTeal,
      onPrimary: ColorManager.mouvemaWhite,
      error: ColorManager.mouvemaError,
      outline: const Color.fromARGB(255, 234, 255, 253),
      surface: const Color.fromARGB(255, 234, 255, 253),
    ),

    // divider
    dividerColor: ColorManager.mouvemaDivider,

    /// App Text Theme
    textTheme: _buildShrineTextTheme(baseLight.textTheme, context, light: true),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: ColorManager.mouvemaWhite,
    ),
    // Scaffold
    scaffoldBackgroundColor: Colors.white,
    // each icon will have this default size
    // iconTheme: IconThemeData(size: size.width * 0.07),

    appBarTheme: const AppBarTheme(
      titleSpacing: 2,
      centerTitle: true,
      foregroundColor: ColorManager.mouvemaBrown,
      backgroundColor: ColorManager.mouvemaWhite,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ColorManager.mouvemaTeal,
        foregroundColor: ColorManager.mouvemaWhite,
        iconSize: 40,
        shape: CircleBorder(),
        splashColor: Color.fromARGB(255, 120, 213, 191)),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color.fromARGB(255, 211, 255, 255),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          width: 0.5,
          color: ColorManager.mouvemaTeal,
        ),
      ),
      floatingLabelStyle: const TextStyle(
        color: ColorManager.mouvemaBrown,
      ),
    ),
  );
  ThemeData darkMode = baseDark.copyWith(
    colorScheme: baseLight.colorScheme.copyWith(
      brightness: Brightness.dark,
      primary: ColorManager.mouvemaTeal,
      onPrimary: ColorManager.mouvemaWhite,
      error: ColorManager.mouvemaError,
      outline: const Color.fromARGB(255, 234, 255, 253),
      surface: const Color.fromARGB(255, 234, 255, 253),
    ),
    scaffoldBackgroundColor: Color.fromARGB(255, 119, 203, 195),

    // divider
    dividerColor: ColorManager.mouvemaDivider,

    /// App Text Theme
    textTheme:
        _buildShrineTextTheme(baseLight.textTheme, context, light: false),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: ColorManager.mouvemaWhite,
    ),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.red),

    appBarTheme: const AppBarTheme(
      titleSpacing: 2,
      centerTitle: true,
      foregroundColor: ColorManager.mouvemaWhite,
      backgroundColor: Color.fromARGB(255, 80, 164, 155),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ColorManager.mouvemaTeal,
        foregroundColor: ColorManager.mouvemaWhite,
        iconSize: 40,
        shape: CircleBorder(),
        splashColor: Color.fromARGB(255, 120, 213, 191)),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color.fromARGB(255, 211, 255, 255),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          width: 0.5,
          color: ColorManager.mouvemaTeal,
        ),
      ),
      floatingLabelStyle: const TextStyle(
        color: ColorManager.mouvemaBrown,
      ),
    ),
  );

  return light ? lightMode : darkMode;
}

// ThemeData oldThemeData() {
//   return ThemeData(
//     useMaterial3: true,

//     // main colors
//     primaryColor: ColorsManager.primary,

//     scaffoldBackgroundColor: ColorsManager.scafoldBackground,

//     // appbar
//     appBarTheme: AppBarTheme(
//       color: ColorsManager.primary,
//       elevation: 4,
//       centerTitle: true,
//     ),
//     textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),

//     elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.black,
//       elevation: 4,
//       foregroundColor: Colors.white,
//     )),
//     textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//       foregroundColor: Colors.white,
//     )),

//     // elevatedButtonTheme: ElevatedButtonThemeData(
//     //     style: ElevatedButton.styleFrom(
//     //       // ! styles should not bet hardcoded
//     //         textStyle: TextStyle(color: ColorsManager.secondary),
//     //         shape: RoundedRectangleBorder(
//     //             borderRadius: BorderRadius.circular(12)))),
//     // todo: nkamlou bqyet les buttons
//     // text field
//     inputDecorationTheme: InputDecorationTheme(
//         contentPadding: const EdgeInsets.all(8),
//         hintStyle: const TextStyle(color: Colors.black38),

//         /// Todo:  [hintStyle] , [labelStyle] ...
//         enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: ColorsManager.enabled, width: 1.5),
//             borderRadius: const BorderRadius.all(Radius.circular(8))),

//         // focused
//         focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: ColorsManager.primary, width: 1.5),
//             borderRadius: const BorderRadius.all(Radius.circular(8))),

//         // error border
//         errorBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: ColorsManager.error, width: 1.5),
//             borderRadius: const BorderRadius.all(Radius.circular(8))),

//         // focused error
//         focusedErrorBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: ColorsManager.primary, width: 1.5),
//             borderRadius: const BorderRadius.all(Radius.circular(8)))),

//     //
//   );
// }
