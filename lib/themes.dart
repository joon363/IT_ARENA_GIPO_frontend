import 'package:flutter/material.dart';
const Color primaryColor = Color(0xFFFF9F31);
const Color blue = Color(0xFF75A9ED);
const Color blue3 = Color(0xFFE6F4FF);
const Color green = Color(0xFF4CC473);
const Color green2 = Color(0xFF8DD196);
const Color green3 = Color(0xFFC1ECC8);
const Color green4 = Color(0xFFECF9E9);
const Color darkBlue = Color(0xFF2D77C1);
const Color darkGreen = Color(0xFF2BB559);
const Color backGround = Color(0xFFFFF5EB);
const Color gray = Color(0xFF8A8A8A);
const Color gray2 = Color(0xFFDBDADC);
const Color gray3 = Color(0xFF9B9A9C);
const Color gray4 = Color(0xFF8A888A);
const Color gray5 = Color(0xFF575558);
const Color errorRed = Color(0xFFFA846C);
const Color orange = Color(0xFFFFBA6A);
const Color org2 = Color(0xFFFFE8C0);
const Color yellow = Color(0xFFFFE56F);
const Color yellow2 = Color(0xFFFEFAE2);
const Color pink = Color(0xFFFE9BA7);


class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
        fontFamily: "Pretendard",
        colorSchemeSeed: Colors.white,
        canvasColor: Colors.white,
        dividerColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        //unselectedWidgetColor: Colors.white,
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          contentTextStyle: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(Colors.white),
          checkColor: WidgetStateProperty.all(Colors.blue),
          overlayColor: WidgetStateProperty.all(gray),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
              color: gray2
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: gray),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: errorRed),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: errorRed),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white),
          trackColor: WidgetStateProperty.all(gray2),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: blue,
          linearTrackColor: blue3,
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: gray2, width: 1),
          ),
        )

    );
  }
}