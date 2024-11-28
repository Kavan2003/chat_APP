import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color accentColor = Color(0xFFFFC107);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFB00020);
  static const Color onPrimaryColor = Color(0xFFFFFFFF);
  static const Color onSecondaryColor = Color(0xFF000000);
  static const Color onBackgroundColor = Color(0xFF000000);
  static const Color onSurfaceColor = Color(0xFF000000);
  static const Color onErrorColor = Color(0xFFFFFFFF);

  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontSize: 26,
    color: onBackgroundColor,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    fontSize: 22,
    color: onBackgroundColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: onBackgroundColor,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: onPrimaryColor,
  );

  // Button Styles
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: onPrimaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  );

  static final ButtonStyle secondaryButton = OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: const BorderSide(color: primaryColor),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  );

  // Input Field Styles
  static final InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: surfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  );

  // Card Styles
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 0,
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Modal Styles
  static final BoxDecoration modalDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        spreadRadius: 0,
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  // Theme Data
  static ThemeData get themeData {
    return ThemeData(
      colorScheme: ColorScheme(
        primary: primaryColor,
        primaryContainer: primaryColor.withOpacity(0.1),
        secondary: secondaryColor,
        secondaryContainer: secondaryColor.withOpacity(0.1),
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: onPrimaryColor,
        onSecondary: onSecondaryColor,
        onSurface: onSurfaceColor,
        onBackground: onBackgroundColor,
        onError: onErrorColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: const TextTheme(
        headlineLarge: heading1,
        headlineMedium: heading2,
        bodyLarge: bodyText,
        labelLarge: buttonText,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: inputDecoration.filled!,
        fillColor: inputDecoration.fillColor,
        border: inputDecoration.border,
        focusedBorder: inputDecoration.focusedBorder,
        contentPadding: inputDecoration.contentPadding,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButton),
      outlinedButtonTheme: OutlinedButtonThemeData(style: secondaryButton),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        titleTextStyle: heading1.copyWith(color: onPrimaryColor),
        iconTheme: const IconThemeData(color: onPrimaryColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: primaryColor,
        selectedItemColor: accentColor,
        unselectedItemColor: onPrimaryColor.withOpacity(0.7),
        selectedLabelStyle: buttonText,
        unselectedLabelStyle:
            buttonText.copyWith(color: onPrimaryColor.withOpacity(0.7)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: onSecondaryColor,
      ),
      cardTheme: CardTheme(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        margin: const EdgeInsets.all(12),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: surfaceColor,
        titleTextStyle: heading1,
        contentTextStyle: bodyText,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(primaryColor),
        checkColor: MaterialStateProperty.all(onPrimaryColor),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(primaryColor),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(primaryColor),
        trackColor: MaterialStateProperty.all(primaryColor.withOpacity(0.5)),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: accentColor,
        unselectedLabelColor: onPrimaryColor.withOpacity(0.7),
        labelStyle: buttonText,
        unselectedLabelStyle:
            buttonText.copyWith(color: onPrimaryColor.withOpacity(0.7)),
        indicator: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: accentColor, width: 2),
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: buttonText.copyWith(color: onPrimaryColor),
      ),
    );
  }
}
