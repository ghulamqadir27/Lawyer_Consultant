import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_consultant_for_lawyers/src/api_services/post_service.dart';
import 'package:lawyer_consultant_for_lawyers/src/screens/agora_call/repo.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_settings_controller.dart';
import '../controllers/general_controller.dart';
import '../repositories/booked_service_status_update_repo.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';

class BookedServiceDetailScreen extends StatefulWidget {
  const BookedServiceDetailScreen({super.key});

  @override
  State<BookedServiceDetailScreen> createState() =>
      BookedServiceDetailScreenState();
}

class BookedServiceDetailScreenState extends State<BookedServiceDetailScreen> {
  @override
  void initState() {
    Get.find<GeneralController>()
                .selectedBookedServiceForView
                .serviceStatusCode ==
            2
        ? getMethod(
            context,
            "$getAgoraTokenUrl?channel=${Get.find<GeneralController>().channelForCall}",
            null,
            true,
            getAgoraTokenRepo)
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
        inAsyncCall: generalController.bookedServiceStatusLoaderController,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              richTextSpan: TextSpan(
                text: LanguageConstant.bookedServiceDetail.tr,
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
            child: Column(children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: BoxDecoration(
                  gradient: AppColors.gradientOne,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    generalController
                                .selectedBookedServiceForView.serviceImage ==
                            null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.asset(
                              scale: 4.h,
                              'assets/images/lawyer-image.png',
                              fit: BoxFit.cover,
                              height: 110.h,
                              width: 120.w,
                            ))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              scale: 4.h,
                              '$mediaUrl${generalController.selectedBookedServiceForView.serviceImage!}',
                              fit: BoxFit.cover,
                              height: 110.h,
                              width: 120.w,
                            )),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // "Client Name",
                          generalController
                              .selectedBookedServiceForView.serviceName!,
                          style: AppTextStyles.bodyTextStyle5,
                        ),
                        SizedBox(height: 16.h),
                        // const Text(
                        //   "Education Law",
                        //   style: AppTextStyles.bodyTextStyle13,
                        // ),
                        // SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.fromLTRB(10.w, 3.h, 10.w, 3.h),
                          decoration: BoxDecoration(
                              color: generalController
                                          .selectedBookedServiceForView
                                          .serviceStatusCode! ==
                                      1
                                  ? AppColors.primaryColor
                                  : generalController
                                              .selectedBookedServiceForView
                                              .serviceStatusCode! ==
                                          5
                                      ? AppColors.green.withOpacity(0.5)
                                      : generalController
                                                  .selectedBookedServiceForView
                                                  .serviceStatusCode! ==
                                              2
                                          ? AppColors.orange.withOpacity(0.5)
                                          : AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            // "Pending",
                            generalController.selectedBookedServiceForView
                                .serviceStatusName!,
                            style: AppTextStyles.bodyTextStyle13,
                          ),
                        ),
                      ],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LanguageConstant.customerName.tr,
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      generalController
                          .selectedBookedServiceForView.customerName!,
                      style: AppTextStyles.bodyTextStyle11,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      LanguageConstant.date.tr,
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      generalController.selectedBookedServiceForView.date!,
                      style: AppTextStyles.bodyTextStyle11,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      LanguageConstant.serviceFee.tr,
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "${Get.find<GetAllSettingsController>().getDisplayAmount(generalController.selectedBookedServiceForView.price!)}",
                      style: AppTextStyles.bodyTextStyle11,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      LanguageConstant.questions.tr,
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      generalController.selectedBookedServiceForView.question ??
                          "",
                      style: AppTextStyles.bodyTextStyle11,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              generalController
                          .selectedBookedServiceForView.serviceStatusCode ==
                      2
                  ? ButtonWidgetOne(
                      onTap: () {
                        generalController
                            .updateTokenForCall(generalController.tokenForCall);
                        Get.toNamed(
                          PageRoutes.liveServiceChatScreen,
                          arguments: [
                            {
                              "service":
                                  generalController.selectedBookedServiceForView
                            },
                          ],
                        );
                      },
                      buttonText: LanguageConstant.chatNow.tr,
                      buttonTextStyle: AppTextStyles.bodyTextStyle8,
                      borderRadius: 10,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonWidgetOne(
                          onTap: () {
                            Get.find<GeneralController>()
                                .updateBookedServiceStatusLoaderController(
                                    true);
                            postMethod(
                                context,
                                "$updateBookedServiceStatusCodeURL${generalController.selectedBookedServiceForView.id}",
                                {"service_status_code": 2},
                                true,
                                bookedServiceStatusUpdateRepo);
                          },
                          buttonText: LanguageConstant.accept.tr,
                          buttonTextStyle: AppTextStyles.bodyTextStyle8,
                          borderRadius: 10,
                        ),
                        SizedBox(width: 40.w),
                        ButtonWidgetOne(
                          onTap: () {
                            Get.find<GeneralController>()
                                .updateBookedServiceStatusLoaderController(
                                    true);
                            postMethod(
                                context,
                                "$updateBookedServiceStatusCodeURL${generalController.selectedBookedServiceForView.id}",
                                {"service_status_code": 3},
                                true,
                                bookedServiceStatusUpdateRepo);
                          },
                          buttonText: LanguageConstant.reject.tr,
                          buttonTextStyle: AppTextStyles.bodyTextStyle8,
                          borderRadius: 10,
                        ),
                      ],
                    )
            ]),
          ),
        ),
      );
    });
  }
}
