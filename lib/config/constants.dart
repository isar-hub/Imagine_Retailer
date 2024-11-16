import 'package:flutter/material.dart';

class ImagineTheme {
  static ThemeData themeData(BuildContext ctx) {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      colorScheme: lightColorScheme,
      appBarTheme: appBarTheme,
      bottomAppBarTheme: bottomAppBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
        scaffoldBackgroundColor: ImagineColors.red,
      iconTheme: const IconThemeData(color: Colors.white)


    );
  }
  static BottomNavigationBarThemeData bottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedIconTheme: const IconThemeData(color: Colors.white),
    unselectedIconTheme: IconThemeData(color: ImagineColors.white.withOpacity(0.5)),

      selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white.withOpacity(0.5),

    selectedLabelStyle: const TextStyle(color: Colors.white),
      unselectedLabelStyle: TextStyle(color: Colors.white.withOpacity(0.5))

  );

  static const BottomAppBarTheme bottomAppBarTheme = BottomAppBarTheme(
    color: Colors.black,
    height: 60,
    padding: EdgeInsets.symmetric(horizontal: 10),
    shape: CircularNotchedRectangle(),
  );
  static const AppBarTheme appBarTheme = AppBarTheme(color: Colors.black);
  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFFcf0000),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF000000),
    onSecondary: Color(0xFFFFFFFF),
    error: Colors.red,
    onError: Colors.white,
    surface: Color(0xFFcf0000),
    onSurface: Color(0xFFFFFFFF),
    brightness: Brightness.dark,
  );
}

class ImagineColors {
  static Color red = const Color(0xFFcf0000);
  static Color black = const Color(0xFF000000);
  static Color white = const Color(0xFFFFFFFF);
}
