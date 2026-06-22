import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xff0A0F24);
  static const Color accentBlue = Color(0xff3E64FF);
  static const Color glassWhite = Colors.white24;

  static const Color bgDark = Color(0xff060B18);
  static const Color textLight = Colors.white;
  static const Color textGrey = Colors.white70;
}

// App Name
const String appName = "Drawify";

// Cloudinary Configuration (Updated with your credentials)
const String cloudinaryCloudName = "dzsshqzrp";
const String cloudinaryUploadPreset = "ml_drawing";

// Cloudinary Upload URL
const String cloudinaryUploadUrl = "https://api.cloudinary.com/v1_1/dzsshqzrp/image/upload";