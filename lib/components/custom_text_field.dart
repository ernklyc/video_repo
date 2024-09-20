import 'package:flutter/material.dart';
import 'package:video_repo/styles/app_colors.dart';
import 'package:video_repo/styles/app_text_styles.dart';
import 'package:video_repo/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Icon? icon;
  final TextEditingController? controller;

  const CustomTextField({
    required this.hintText,
    super.key,
    required this.icon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.hintStyle,
        filled: true,
        fillColor: AppColors.black12,
        suffixIcon: icon,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(AppBorders.radius),
        ),
      ),
    );
  }
}
