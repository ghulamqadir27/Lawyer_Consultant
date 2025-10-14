import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';

class PaymentDetailScreen extends StatefulWidget {
  PaymentDetailScreen({super.key});

  @override
  State<PaymentDetailScreen> createState() => PaymentDetailScreenState();
}

class PaymentDetailScreenState extends State<PaymentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: AppBarWidget(
          richTextSpan: TextSpan(
            text: LanguageConstant.paymentDetail.tr,
            style: AppTextStyles.appbarTextStyle2,
            children: <TextSpan>[],
          ),
          leadingIcon: "assets/icons/Expand_left.png",
          leadingOnTap: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
              decoration: BoxDecoration(
                gradient: AppColors.gradientOne,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    LanguageConstant.paymentSuccess.tr,
                    style: AppTextStyles.bodyTextStyle5,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "\$150.00",
                    style: AppTextStyles.bodyTextStyle5,
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              decoration: BoxDecoration(
                  color: AppColors.tertiaryBgColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reference No",
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "1234455687788",
                      style: AppTextStyles.bodyTextStyle11,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Date & Time",
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "25th March, 2023  |  10:20 PM ",
                      style: AppTextStyles.bodyTextStyle11,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Sender",
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "Jhon Doe",
                      style: AppTextStyles.bodyTextStyle11,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Card Number",
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "1234564567890123456",
                      style: AppTextStyles.bodyTextStyle11,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Payment Details",
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "Lorum Ipsum Dollar site emeit Lorum Ipsum Dollar site emeit Lorum Ipsum Dollar site emeit Lorum Ipsum Dollar site emeit",
                      style: AppTextStyles.bodyTextStyle11,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 36.h),
            ButtonWidgetOne(
              onTap: () {
                Get.toNamed(PageRoutes.homeScreen);
              },
              buttonText: "Back to Home",
              buttonTextStyle: AppTextStyles.bodyTextStyle8,
              borderRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
