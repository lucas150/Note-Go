import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF2B2B2B); // Dark Grey Background
  static const Color card = Color(0xFF3C3C3C); // Slightly lighter Grey Card
  static const Color chip = Color(0xFF4D4D4D); // Mid Grey Chip Background

  // Text
  static const Color textPrimary = Color(0xFFEFEFEF); // Off-White Text
  static const Color textSecondary = Color(0xFFB0B0B0); // Muted Grey Text
  static const Color cardText = Color(0xFFFFFFFF); // Bright White for Card Text
  // Shadows
  static const Color shadow = Color(0xFF000000);

  // Buttons & Highlights
  static const Color primary =
      Color.fromARGB(255, 5, 255, 222); // Teal/Aqua Accent
  static const Color secondary =
      Color.fromARGB(255, 5, 255, 222); // Lighter Teal for Secondary
  static const Color buttonText =
      Color(0xFF000000); // Dark Text on Accent Buttons

  // Borders & Dividers
  static const Color border = Color(0xFF555555); // Subtle Grey Borders/Dividers

  // Alerts
  static const Color delete =
      Color.fromARGB(255, 172, 8, 8); // Bright Red for Delete Actions
  static const Color incomeDisplay =
      Color.fromARGB(255, 76, 175, 80); // A green
  static const Color expenseDisplay = Color.fromARGB(255, 244, 67, 54); // A red
  static const Color success =
      Color.fromARGB(255, 76, 175, 80); // A green for success SnackBar
  static const Color error =
      Color.fromARGB(255, 244, 67, 54); // A red for error SnackBar
}
