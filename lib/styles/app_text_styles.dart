import 'package:flutter/material.dart';
import 'package:video_repo/styles/app_colors.dart';

class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 24,
    color: AppColors.black87,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle hintStyle = TextStyle(
    color: AppColors.black38,
  );

  static const TextStyle modalTitle = TextStyle(
    fontSize: 18,
    color: AppColors.black87,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle modalButtonText = TextStyle(
    fontSize: 16,
    color: AppColors.white,
  );

  static const TextStyle selectVideoText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}
