import 'package:expresto/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:expresto/core/theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'sans-serif',
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.panel,
          contentTextStyle: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      home: const HomePage(),
    );
  }
}
