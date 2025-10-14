import 'package:flutter/material.dart';
import 'package:lawyer_consultant_for_lawyers/src/config/app_font.dart';
import 'package:resize/resize.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static var appbarTextStyle1 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.black,
      fontWeight: FontWeight.w700,
      fontFamily: AppFont.primaryFontFamily);

  static var appbarTextStyle2 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.black,
      fontWeight: FontWeight.w700,
      fontFamily: AppFont.primaryFontFamily);

  static var headingTextStyle1 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.black,
      fontWeight: FontWeight.w400,
      fontFamily: AppFont.primaryFontFamily);

  static var headingTextStyle2 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.black,
      fontWeight: FontWeight.w700,
      fontFamily: AppFont.primaryFontFamily);

  static var headingTextStyle3 = TextStyle(
      fontSize: 16.sp,
      color: AppColors.black,
      fontWeight: FontWeight.w700,
      fontFamily: AppFont.primaryFontFamily);

  static var headingTextStyle4 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );

  // Subheading Text Styles

  static var subHeadingTextStyle1 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var subHeadingTextStyle2 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var subHeadingTextStyle3 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: AppColors.white,
    fontFamily: AppFont.primaryFontFamily,
  );

// Button Text Styles

  static var buttonTextStyle1 = TextStyle(
      color: AppColors.white,
      fontFamily: AppFont.primaryFontFamily,
      fontSize: 22.sp,
      fontWeight: FontWeight.w700);

  static var buttonTextStyle2 = TextStyle(
      color: AppColors.white,
      fontFamily: AppFont.primaryFontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w700);

  static var buttonTextStyle3 = TextStyle(
      fontSize: 16.0,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w700,
      fontFamily: AppFont.primaryFontFamily);

  static var buttonTextStyle4 = TextStyle(
      fontSize: 10.0,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w700,
      fontFamily: AppFont.primaryFontFamily);

  static var buttonTextStyle5 = TextStyle(
      fontSize: 10.sp,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
      fontFamily: AppFont.primaryFontFamily);

  static var buttonTextStyle6 = TextStyle(
      fontSize: 10.0,
      color: AppColors.secondaryColor,
      fontWeight: FontWeight.w700,
      fontFamily: AppFont.primaryFontFamily);

  static var buttonTextStyle7 = TextStyle(
      color: AppColors.white,
      fontFamily: AppFont.primaryFontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w700);

  static var buttonTextStyle8 = TextStyle(
      color: AppColors.black,
      fontFamily: AppFont.primaryFontFamily,
      fontSize: 16.sp,
      fontWeight: FontWeight.w700);

  static var hintTextStyle1 = TextStyle(
      color: AppColors.black,
      fontFamily: AppFont.primaryFontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500);

  static var bodyTextStyle1 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var bodyTextStyle2 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var bodyTextStyle3 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var bodyTextStyle4 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 9.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var bodyTextStyle5 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14.sp,
    color: AppColors.white,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var bodyTextStyle6 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10.sp,
    color: AppColors.white,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var bodyTextStyle7 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var bodyTextStyle8 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 22.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var bodyTextStyle9 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12.sp,
    color: AppColors.white,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var bodyTextStyle10 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );

  static final bodyTextStyle11 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var bodyTextStyle12 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var bodyTextStyle13 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    color: AppColors.white,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var bodyTextStyle14 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24.sp,
    color: AppColors.white,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var bodyTextStyle15 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );
  static var bodyTextStyle16 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: AppColors.secondaryColor,
    fontFamily: AppFont.primaryFontFamily,
  );
  static var bodyTextStyle17 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );
  static var bodyTextStyle18 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    color: AppColors.white,
    fontFamily: AppFont.primaryFontFamily,
  );

// Chips Widget Text Style

  static var chipsTextStyle1 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: AppColors.black,
    fontFamily: AppFont.primaryFontFamily,
  );

  static var chipsTextStyle2 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: AppColors.white,
    fontFamily: AppFont.primaryFontFamily,
  );

  // Underline Text Style

  static var underlineTextStyle1 = TextStyle(
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.secondaryColor,
    fontFamily: AppFont.primaryFontFamily,
  );
}
