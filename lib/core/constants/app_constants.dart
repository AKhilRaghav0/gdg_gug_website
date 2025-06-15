import 'package:flutter/material.dart';

class AppConstants {
  // Google Brand Colors (Material Design 3)
  static const Color googleBlue = Color(0xFF1A73E8);   // primary.500
  static const Color googleGreen = Color(0xFF34A853);  // secondary.400
  static const Color googleRed = Color(0xFFEA4335);    // error.400
  static const Color googleYellow = Color(0xFFFBBC04); // warning.400

  // Neutral Colors
  static const Color neutral50 = Color(0xFFF8F9FA);
  static const Color neutral100 = Color(0xFFF1F3F4);
  static const Color neutral200 = Color(0xFFE8EAED);
  static const Color neutral300 = Color(0xFFDADCE0);
  static const Color neutral400 = Color(0xFFBDC1C6);
  static const Color neutral500 = Color(0xFF9AA0A6);
  static const Color neutral600 = Color(0xFF80868B);
  static const Color neutral700 = Color(0xFF5F6368);
  static const Color neutral800 = Color(0xFF3C4043);
  static const Color neutral900 = Color(0xFF202124);

  // Primary Color Palette
  static const Color primary50 = Color(0xFFE8F0FE);
  static const Color primary100 = Color(0xFFC2D7FE);
  static const Color primary200 = Color(0xFF99BCFD);
  static const Color primary300 = Color(0xFF69A0FC);
  static const Color primary400 = Color(0xFF4285F4);
  static const Color primary500 = Color(0xFF1B73E8);
  static const Color primary600 = Color(0xFF1557B0);
  static const Color primary700 = Color(0xFF0D3C78);
  static const Color primary800 = Color(0xFF062E40);
  static const Color primary900 = Color(0xFF041E28);

  // App Info
  static const String appName = 'GDG Gurugram University';
  static const String appDescription = 'Join our vibrant community of developers, connect with Google Developer Experts, and explore the latest in technology.';
  
  // Contact Info
  static const String email = 'gdg@ggsipu.ac.in';
  static const String phone = '+91 98765 43210';
  static const String address = 'Guru Gobind Singh Indraprastha University, Dwarka, New Delhi';
  
  // Social Media
  static const String facebookUrl = 'https://facebook.com/gdggug';
  static const String twitterUrl = 'https://twitter.com/gdggug';
  static const String linkedinUrl = 'https://linkedin.com/company/gdggug';
  static const String instagramUrl = 'https://instagram.com/gdggug';
  static const String githubUrl = 'https://github.com/gdggug';
  
  // Breakpoints
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1200;
  
  // Layout
  static const double maxContentWidth = 1400;
  static const double defaultPadding = 16;
  static const double sectionPadding = 64;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
} 