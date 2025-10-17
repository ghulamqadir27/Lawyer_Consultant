import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_consultant_for_lawyers/src/controllers/lawyer_booked_services_controller.dart';
import 'package:lawyer_consultant_for_lawyers/src/models/lawyer_booked_services_model.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';

import '../routes.dart';

import '../widgets/appbar_widget.dart';
import '../widgets/custom_skeleton_loader.dart';

class BookedServicesScreen extends StatefulWidget {
  const BookedServicesScreen({super.key});

  @override
  State<BookedServicesScreen> createState() => _BookedServicesScreenState();
}

class _BookedServicesScreenState extends State<BookedServicesScreen> {
  final logic = Get.put(LawyerBookedServicesController());

  List<LawyerBookedServiceModel>? pendingList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LawyerBookedServicesController>(
        builder: (lawyerBookedServicesController) {
      return GetBuilder<GeneralController>(builder: (generalController) {
        return DefaultTabController(
          length: 4, // length of tabs
          initialIndex: 0,
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBarWidget(
                richTextSpan: TextSpan(
                  text: LanguageConstant.bookedServices.tr,
                  style: AppTextStyles.appbarTextStyle2,
                  children: <TextSpan>[],
                ),
                leadingIcon: "assets/icons/Expand_left.png",
                leadingOnTap: () {
                  // fromBookService == "Yes"
                  //     ? Get.toNamed(PageRoutes.homeScreen)
                  //     :
                  Get.back();
                },
              ),
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Theme(
                    data: ThemeData().copyWith(dividerColor: AppColors.black),
                    child: TabBar(
                      labelColor: AppColors.white,
                      unselectedLabelColor: AppColors.black,
                      dividerColor: AppColors.transparent,
                      padding: const EdgeInsets.fromLTRB(3, 6, 3, 6),
                      indicatorPadding: const EdgeInsets.fromLTRB(-6, 4, -6, 4),
                      labelPadding: EdgeInsets.zero,
                      labelStyle: AppTextStyles.buttonTextStyle2,
                      unselectedLabelStyle: AppTextStyles.buttonTextStyle7,
                      indicator: BoxDecoration(
                          gradient: AppColors.gradientOne,
                          borderRadius: BorderRadius.circular(10)),
                      tabs: [
                        Tab(
                          text: LanguageConstant.all.tr,
                        ),
                        Tab(
                          text: LanguageConstant.pending.tr,
                        ),
                        Tab(
                          text: LanguageConstant.accepted.tr,
                        ),
                        Tab(
                          text: LanguageConstant.completed.tr,
                        ),
                      ],
                    ),
                  ),
                  !lawyerBookedServicesController.allLawyerBookedServicesLoader
                      ? Expanded(
                          child: CustomVerticalSkeletonLoader(
                            height: 200.h,
                            highlightColor: AppColors.grey,
                            seconds: 2,
                            totalCount: 5,
                            width: 140.w,
                          ),
                        )
                      : Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 1))),
                            child: TabBarView(children: <Widget>[
                              // All Appointment History
                              lawyerBookedServicesController
                                      .lawyerAllBookedServicesListForPagination
                                      .isNotEmpty
                                  ? ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: lawyerBookedServicesController
                                          .lawyerAllBookedServicesListForPagination
                                          .length,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      padding: const EdgeInsets.only(top: 18),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              18, 0, 18, 18),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 12, 12, 12),
                                                // margin:  EdgeInsets.fromLTRB(8, 8, 8, 8),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.tertiaryBgColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        lawyerBookedServicesController
                                                                    .lawyerAllBookedServicesListForPagination[
                                                                        index]
                                                                    .serviceImage ==
                                                                null
                                                            ? ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(8
                                                                            .r),
                                                                child:
                                                                    Image.asset(
                                                                  scale: 4.h,
                                                                  'assets/images/lawyer-image.png',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 110.h,
                                                                  width: 120.w,
                                                                ))
                                                            : ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.r),
                                                                child: Image
                                                                    .network(
                                                                  scale: 4.h,
                                                                  '$mediaUrl${lawyerBookedServicesController.lawyerAllBookedServicesListForPagination[index].serviceImage!}',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 110.h,
                                                                  width: 120.w,
                                                                ),
                                                              ),
                                                        SizedBox(
                                                          width: 12.w,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      // "Jhon Doe",
                                                                      lawyerBookedServicesController
                                                                          .lawyerAllBookedServicesListForPagination[
                                                                              index]
                                                                          .serviceName!,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: AppTextStyles
                                                                          .bodyTextStyle10,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .fromLTRB(
                                                                            5,
                                                                            2,
                                                                            5,
                                                                            2),
                                                                    decoration: BoxDecoration(
                                                                        color: lawyerBookedServicesController.lawyerAllBookedServicesListForPagination[index].serviceStatusName! == "Pending"
                                                                            ? AppColors.primaryColor
                                                                            : lawyerBookedServicesController.lawyerAllBookedServicesListForPagination[index].serviceStatusName! == "Completed"
                                                                                ? AppColors.green.withOpacity(0.5)
                                                                                : lawyerBookedServicesController.lawyerAllBookedServicesListForPagination[index].serviceStatusName! == "Accepted"
                                                                                    ? AppColors.orange.withOpacity(0.5)
                                                                                    : AppColors.primaryColor,
                                                                        borderRadius: BorderRadius.circular(5)),
                                                                    child: Text(
                                                                      // "Pending",
                                                                      lawyerBookedServicesController
                                                                          .lawyerAllBookedServicesListForPagination[
                                                                              index]
                                                                          .serviceStatusName!,
                                                                      style: AppTextStyles
                                                                          .bodyTextStyle4,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 16.h,
                                                              ),
                                                              Text(
                                                                lawyerBookedServicesController
                                                                        .lawyerAllBookedServicesListForPagination[
                                                                            index]
                                                                        .customerName ??
                                                                    "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: AppTextStyles
                                                                    .bodyTextStyle3,
                                                              ),
                                                              SizedBox(
                                                                height: 16.h,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  generalController
                                                                      .updateChannelForCall(
                                                                          generalController
                                                                              .getRandomString(10));
                                                                  print(
                                                                      "${generalController.channelForCall} CALLCHANNEL");
                                                                  setState(() {
                                                                    generalController
                                                                            .appointmentObject =
                                                                        lawyerBookedServicesController
                                                                            .lawyerAllBookedServicesListForPagination[index]
                                                                            .toJson();
                                                                  });
                                                                  generalController
                                                                      .updateSelectedBookedServicesForView(
                                                                          lawyerBookedServicesController
                                                                              .lawyerAllBookedServicesListForPagination[index]);
                                                                  Get.toNamed(
                                                                      PageRoutes
                                                                          .bookedServiceDetailScreen);
                                                                },
                                                                child: Text(
                                                                  LanguageConstant
                                                                      .viewDetail
                                                                      .tr,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: AppTextStyles
                                                                      .bodyTextStyle1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 8, 20, 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(10),
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                    ),
                                                    gradient:
                                                        AppColors.gradientOne),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          "assets/icons/Date_range_light.png",
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                        SizedBox(width: 5.w),
                                                        Text(
                                                          // "Mon, 28th March, 2023",
                                                          lawyerBookedServicesController
                                                              .lawyerAllBookedServicesListForPagination[
                                                                  index]
                                                              .date!,
                                                          style: AppTextStyles
                                                              .bodyTextStyle6,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          "assets/icons/🦆 icon _comments_.png",
                                                          height: 16.h,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                        SizedBox(width: 5.w),
                                                        Text(
                                                          LanguageConstant
                                                              .service.tr,
                                                          style: AppTextStyles
                                                              .bodyTextStyle6,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                        LanguageConstant.noDataFound.tr,
                                        style: AppTextStyles.bodyTextStyle2,
                                      ),
                                    ),
                              // Pending Appointment History
                              bookedServicesWidget(
                                  1,
                                  lawyerBookedServicesController,
                                  generalController),
                              // Accepted Appointment History
                              bookedServicesWidget(
                                  2,
                                  lawyerBookedServicesController,
                                  generalController),
                              // Completed Appointment History
                              bookedServicesWidget(
                                  5,
                                  lawyerBookedServicesController,
                                  generalController),
                            ]),
                          ),
                        )
                ]),
          ),
        );
      });
    });
  }

// Appointment History
  Widget bookedServicesWidget(
      int statusCode,
      LawyerBookedServicesController lawyerBookedServicesController,
      GeneralController generalController) {
    return lawyerBookedServicesController
            .lawyerAllBookedServicesListForPagination
            .where((i) => i.serviceStatusCode == statusCode)
            .toList()
            .isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // ignore: iterable_contains_unrelated_type
            itemCount: lawyerBookedServicesController
                .lawyerAllBookedServicesListForPagination
                .where((i) => i.serviceStatusCode == statusCode)
                .toList()
                .length,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 18),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      // margin:  EdgeInsets.fromLTRB(8, 8, 8, 8),
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryBgColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              // ClipRRect(
                              //   borderRadius:
                              //       BorderRadius.circular(
                              //           10),
                              //   child:  Image(
                              //     image: AssetImage(
                              //         'assets/images/lawyer-image.png'),
                              //   ),
                              // ),
                              lawyerBookedServicesController
                                          .lawyerAllBookedServicesListForPagination[
                                              index]
                                          .serviceImage ==
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
                                        '$mediaUrl${lawyerBookedServicesController.lawyerAllBookedServicesListForPagination[index].serviceImage!}',
                                        fit: BoxFit.cover,
                                        height: 110.h,
                                        width: 120.w,
                                      ),
                                    ),
                              SizedBox(
                                width: 12.w,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            // "Jhon Doe",
                                            lawyerBookedServicesController
                                                .lawyerAllBookedServicesListForPagination
                                                .where((i) =>
                                                    i.serviceStatusCode ==
                                                    statusCode)
                                                .toList()[index]
                                                .serviceName!,
                                            textAlign: TextAlign.start,
                                            style:
                                                AppTextStyles.bodyTextStyle10,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 2, 5, 2),
                                          decoration: BoxDecoration(
                                              color: lawyerBookedServicesController
                                                          .lawyerAllBookedServicesListForPagination
                                                          .where((i) =>
                                                              i.serviceStatusCode ==
                                                              statusCode)
                                                          .toList()[index]
                                                          .serviceStatusCode! ==
                                                      1
                                                  ? AppColors.primaryColor
                                                  : lawyerBookedServicesController
                                                              .lawyerAllBookedServicesListForPagination
                                                              .where((i) =>
                                                                  i.serviceStatusCode ==
                                                                  statusCode)
                                                              .toList()[index]
                                                              .serviceStatusCode! ==
                                                          5
                                                      ? AppColors.green
                                                          .withOpacity(0.5)
                                                      : lawyerBookedServicesController
                                                                  .lawyerAllBookedServicesListForPagination
                                                                  .where((i) =>
                                                                      i.serviceStatusCode ==
                                                                      statusCode)
                                                                  .toList()[index]
                                                                  .serviceStatusCode! ==
                                                              2
                                                          ? AppColors.orange.withOpacity(0.5)
                                                          : AppColors.primaryColor,
                                              borderRadius: BorderRadius.circular(5)),
                                          child: Text(
                                            // statusCode,
                                            lawyerBookedServicesController
                                                .lawyerAllBookedServicesListForPagination
                                                .where((i) =>
                                                    i.serviceStatusCode ==
                                                    statusCode)
                                                .toList()[index]
                                                .serviceStatusName!,
                                            style: AppTextStyles.bodyTextStyle4,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16.h,
                                    ),
                                    Text(
                                      lawyerBookedServicesController
                                              .lawyerAllBookedServicesListForPagination
                                              .where((i) =>
                                                  i.serviceStatusCode ==
                                                  statusCode)
                                              .toList()[index]
                                              .customerName ??
                                          "",
                                      textAlign: TextAlign.start,
                                      style: AppTextStyles.bodyTextStyle3,
                                    ),
                                    SizedBox(
                                      height: 16.h,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        generalController
                                            .updateSelectedBookedServicesForView(
                                                lawyerBookedServicesController
                                                    .lawyerAllBookedServicesListForPagination
                                                    .where((i) =>
                                                        i.serviceStatusCode ==
                                                        statusCode)
                                                    .toList()[index]);
                                        Get.toNamed(PageRoutes
                                            .bookedServiceDetailScreen);
                                      },
                                      child: Text(
                                        LanguageConstant.viewDetail.tr,
                                        textAlign: TextAlign.start,
                                        style: AppTextStyles.bodyTextStyle1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          gradient: AppColors.gradientOne),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/Date_range_light.png",
                                color: AppColors.black,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                // "Mon, 28th March, 2023",
                                lawyerBookedServicesController
                                    .lawyerAllBookedServicesListForPagination
                                    .where((i) =>
                                        i.serviceStatusCode == statusCode)
                                    .toList()[index]
                                    .date!,
                                style: AppTextStyles.bodyTextStyle6,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/🦆 icon _comments_.png",
                                color: AppColors.black,
                                height: 16.h,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                LanguageConstant.service.tr,
                                style: AppTextStyles.bodyTextStyle6,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : Center(
            child: Text(
              LanguageConstant.noDataFound.tr,
              style: AppTextStyles.bodyTextStyle2,
            ),
          );
  }
}
