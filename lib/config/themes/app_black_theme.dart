import 'package:flutter/material.dart';

ThemeData darkThemeData() => ThemeData(
  fontFamily: "Roboto",
  useMaterial3: true,
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    // color: AppColors.blackColor,
    centerTitle: true,
  ),
  // scaffoldBackgroundColor: AppColors.blackColor,
);
