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
import '../controllers/general_controller.dart';
import '../repositories/appointment_status_update_repo.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({super.key});

  @override
  State<AppointmentDetailScreen> createState() =>
      AppointmentDetailScreenState();
}

class AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  void initState() {
    Get.find<GeneralController>()
                .selectedAppointmentHistoryForView
                .appointmentStatusCode ==
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
        inAsyncCall: generalController.appointmentStatusLoaderController,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              richTextSpan: TextSpan(
                text: LanguageConstant.appointmentDetail.tr,
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
                    generalController.selectedAppointmentHistoryForView
                                .customerImage ==
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
                              '$mediaUrl${generalController.selectedAppointmentHistoryForView.customerImage!}',
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
                          generalController.selectedAppointmentHistoryForView
                                  .customerName ??
                              "",
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
                                          .selectedAppointmentHistoryForView
                                          .appointmentStatusCode! ==
                                      1
                                  ? AppColors.primaryColor
                                  : generalController
                                              .selectedAppointmentHistoryForView
                                              .appointmentStatusCode! ==
                                          5
                                      ? AppColors.green.withOpacity(0.5)
                                      : generalController
                                                  .selectedAppointmentHistoryForView
                                                  .appointmentStatusCode! ==
                                              2
                                          ? AppColors.orange.withOpacity(0.5)
                                          : AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            // "Pending",
                            generalController.selectedAppointmentHistoryForView
                                .appointmentStatusName!,
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
                      LanguageConstant.appointmentType.tr,
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      generalController.selectedAppointmentHistoryForView
                          .appointmentTypeName!,
                      style: AppTextStyles.bodyTextStyle11,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      LanguageConstant.dateAndTime.tr,
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "${generalController.selectedAppointmentHistoryForView.date!} - ${generalController.selectedAppointmentHistoryForView.startTime}",
                      style: AppTextStyles.bodyTextStyle11,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      LanguageConstant.fee.tr,
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "${generalController.selectedAppointmentHistoryForView.fee!}",
                      style: AppTextStyles.bodyTextStyle11,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      LanguageConstant.questions.tr,
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      generalController
                              .selectedAppointmentHistoryForView.question ??
                          "",
                      style: AppTextStyles.bodyTextStyle11,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              generalController.selectedAppointmentHistoryForView
                          .appointmentStatusCode ==
                      2
                  ? generalController.selectedAppointmentHistoryForView
                              .appointmentTypeId ==
                          1
                      ? ButtonWidgetOne(
                          onTap: () {
                            generalController.updateTokenForCall(
                                generalController.tokenForCall);
                            Get.toNamed(PageRoutes.videoCallScreen, arguments: [
                              {
                                "appointment": generalController
                                    .selectedAppointmentHistoryForView
                              },
                            ]);
                          },
                          buttonText: generalController
                              .selectedAppointmentHistoryForView
                              .appointmentTypeName!,
                          buttonTextStyle: AppTextStyles.buttonTextStyle1,
                          borderRadius: 10,
                        )
                      : generalController.selectedAppointmentHistoryForView
                                  .appointmentTypeId ==
                              2
                          ? ButtonWidgetOne(
                              onTap: () {
                                generalController.updateTokenForCall(
                                    generalController.tokenForCall);
                                Get.toNamed(PageRoutes.audioCallScreen,
                                    arguments: [
                                      {
                                        "appointment": generalController
                                            .selectedAppointmentHistoryForView
                                      },
                                    ]);
                              },
                              buttonText: generalController
                                  .selectedAppointmentHistoryForView
                                  .appointmentTypeName!,
                              buttonTextStyle: AppTextStyles.buttonTextStyle1,
                              borderRadius: 10,
                            )
                          : generalController.selectedAppointmentHistoryForView
                                      .appointmentTypeId ==
                                  3
                              ? ButtonWidgetOne(
                                  onTap: () {
                                    generalController.updateTokenForCall(
                                        generalController.tokenForCall);
                                    Get.toNamed(PageRoutes.liveChatScreen,
                                        arguments: [
                                          {
                                            "appointment": generalController
                                                .selectedAppointmentHistoryForView
                                          },
                                        ]);
                                  },
                                  buttonText: generalController
                                      .selectedAppointmentHistoryForView
                                      .appointmentTypeName!,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle1,
                                  borderRadius: 10,
                                )
                              : Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonWidgetOne(
                          onTap: () {
                            Get.find<GeneralController>()
                                .updateAppointmentStatusLoaderController(true);
                            postMethod(
                                context,
                                "$updateAppointmentStatusCodeURL${generalController.selectedAppointmentHistoryForView.id}",
                                {"appointment_status_code": 2},
                                true,
                                appointmentStatusUpdateRepo);
                          },
                          buttonText: LanguageConstant.accept.tr,
                          buttonTextStyle: AppTextStyles.bodyTextStyle8,
                          borderRadius: 10,
                        ),
                        SizedBox(width: 40.w),
                        ButtonWidgetOne(
                          onTap: () {
                            Get.find<GeneralController>()
                                .updateAppointmentStatusLoaderController(true);
                            postMethod(
                                context,
                                "$updateAppointmentStatusCodeURL${generalController.selectedAppointmentHistoryForView.id}",
                                {"appointment_status_code": 3},
                                true,
                                appointmentStatusUpdateRepo);
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
