// Audio Call Appointment Slots Widget
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_consultant_for_lawyers/src/controllers/all_settings_controller.dart';
import 'package:resize/resize.dart';
import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/appoinment_commission_controller.dart';
import '../controllers/appoinment_schedules_controller.dart';
import '../controllers/general_controller.dart';
import '../controllers/generate_schedule_slots_controller.dart';
import '../repositories/appointment_schedules_repo.dart';
import '../repositories/delete_appointment_schedules_repo.dart';
import '../repositories/generate_appointment_schedule_slots_repo.dart';
import '../repositories/get_appointment_commission_repo.dart';
import '../routes.dart';
import 'button_widget.dart';
import 'select_week_days_widget.dart';
import 'text_form_field_widget.dart';

class AudioCallAppointmentSlotsWidget extends StatefulWidget {
  const AudioCallAppointmentSlotsWidget({super.key});

  @override
  State<AudioCallAppointmentSlotsWidget> createState() =>
      _AudioCallAppointmentSlotsWidgetState();
}

class _AudioCallAppointmentSlotsWidgetState
    extends State<AudioCallAppointmentSlotsWidget> {
  final logic = Get.put(GenerateScheduleSlotsController());
  final appointmentSchedulelogic = Get.put(GetAppoinmentSchedulesController());
  int? value = 1;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  TimeOfDay? forSingleDayStartTime;
  TimeOfDay? forSingleDayEndTime;
  TimeOfDay? newTime;
  dynamic totalFee = "";
  dynamic totalFeeForSingleDay = "";

  bool isGenerating = false;

  bool isWeekDaysLoading = true;

  Map<String, List<Map<String, dynamic>>> generatedSlots = {};
  Map<String, List<Map<String, dynamic>>> singleDayGeneratedSlots = {};

  int? intervalMinutes;
  bool isActive = true;
  List<String> selectedDays = [];
  String selectedDay = "";
  bool isSingleDayOn = false;
  List<String> weekDays = [
    LanguageConstant.sunday.tr,
    LanguageConstant.monday.tr,
    LanguageConstant.tuesday.tr,
    LanguageConstant.wednesday.tr,
    LanguageConstant.thursday.tr,
    LanguageConstant.friday.tr,
    LanguageConstant.saturday.tr,
  ];

  // Select Start Time Function
  void selectStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        startTime = newTime;
      });
    }
  }

// Select End Time Function
  void selectEndTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        endTime = newTime;
      });
    }
  }

  // Select Alert Dialog Start Time Function
  void forSingleDaySelectStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        forSingleDayStartTime = newTime;
      });
    }
  }

// Select Alert Dialog End Time Function
  void forSingleDaySelectEndTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        forSingleDayEndTime = newTime;
      });
    }
  }

  void generateSlots() {
    log("--- Generating Slots ---");
    log("Selected Days: $selectedDays");
    log("Start Time: $startTime");
    log("End Time: $endTime");
    log("Interval (minutes): $intervalMinutes");
    final newSlots = generateTimeSlot();
    setState(() {
      generatedSlots = newSlots;
    });
    log("$generatedSlots TESTING");
  }

  void forSingleDayGenerateSlots() {
    singleDayGeneratedSlots = forSingleDayGenerateTimeSlot();

    print("$singleDayGeneratedSlots TESTING");
  }

  Map<String, List<Map<String, dynamic>>> generateTimeSlot() {
    if (generatedSlots.containsKey('key')) {}
    generatedSlots.clear();
    for (String day in selectedDays) {
      if (generatedSlots.containsKey(day)) continue;

      generatedSlots[day] = [];

      TimeOfDay currentStartTime = startTime!;

      setState(() {
        isGenerating = true;
      });

      while (currentStartTime.hour * 60 + currentStartTime.minute <
          endTime!.hour * 60 + endTime!.minute) {
        log("Running");

        int addHour = currentStartTime.hour * 60 +
            currentStartTime.minute +
            intervalMinutes!;
        var currentEndTime =
            TimeOfDay(hour: addHour ~/ 60, minute: addHour % 60);

        if (currentEndTime.hour > endTime!.hour ||
            (currentEndTime.hour == endTime!.hour &&
                currentEndTime.minute > endTime!.minute)) {
          // Adjust the end time to be equal to or less than the end time provided.
          currentEndTime = endTime!;
        }

        generatedSlots[day]!.add({
          'start_time': currentStartTime.format(context),
          'end_time': currentEndTime.format(context),
          'is_active': true,
        });
        log("${currentStartTime.format(context)} CurrentStartTime");
        log("${currentEndTime.format(context)} CurrentEndTime");

        currentStartTime = currentEndTime;
      }
    }

    setState(() => isGenerating = false);

    return generatedSlots;
  }

  Map<String, List<Map<String, dynamic>>> forSingleDayGenerateTimeSlot() {
    if (singleDayGeneratedSlots.containsKey('key')) {}

    singleDayGeneratedSlots[selectedDay] = [];

    TimeOfDay currentStartTime = forSingleDayStartTime!;

    while (currentStartTime.hour * 60 + currentStartTime.minute <
        forSingleDayEndTime!.hour * 60 + forSingleDayEndTime!.minute) {
      log("Running");
      setState(() {
        isGenerating = true;
      });

      int addHour = currentStartTime.hour * 60 +
          currentStartTime.minute +
          intervalMinutes!;
      var currentEndTime = currentStartTime.replacing(
        hour: addHour ~/ 60,
        minute: addHour % 60,
      );

      if (currentEndTime.hour > forSingleDayEndTime!.hour ||
          (currentEndTime.hour == forSingleDayEndTime!.hour &&
              currentEndTime.minute > forSingleDayEndTime!.minute)) {
        // Adjust the end time to be equal to or less than the end time provided.
        currentEndTime = forSingleDayEndTime!;
      }

      if (singleDayGeneratedSlots[selectedDay] != null) {
        singleDayGeneratedSlots[selectedDay]!.add({
          'start_time': currentStartTime.format(context),
          'end_time': currentEndTime.format(context),
          'is_active': true,
        });
      }

      log("${currentStartTime.format(context)} CurrentStartTime");
      log("${currentEndTime.format(context)} CurrentEndTime");

      currentStartTime = currentEndTime;
    }

    setState(() {
      isGenerating = false;
    });

    return singleDayGeneratedSlots;
  }

  @override
  void initState() {
    super.initState();
    // Get Appointment Commission Data
    getMethod(
        context,
        "$getAppointmentScheduleCommissionUrl?appointment_type_id=2",
        null,
        true,
        getAppointmentCommissionRepo);
    if (mounted) {
      Future.delayed(const Duration(seconds: 2), () {
        getMethod(
            Get.context!,
            "$getAppointmentScheduleSlotsUrl?appointment_type_id=2&is_schedule_required=1",
            null,
            true,
            getAppoinmentSchedulesRepo);
      })
          .whenComplete(() =>
              Future.delayed(const Duration(seconds: 5), () async {
                Map response;
                if (mounted) {
                  setState(() {
                    if (Get.find<GetAppoinmentSchedulesController>()
                            .getAppointmentSchedulesModel
                            .data !=
                        null) {
                      response = Get.find<GetAppoinmentSchedulesController>()
                          .getAppointmentSchedulesModel
                          .data!
                          .toJson();

                      var savedSlots = {};
                      log("$response VALUE1");
                      response.forEach((day, value) {
                        log("${day.toString()} DAY");
                        log("${value["schedule_slots"]} VALUE");

                        savedSlots[day] = value["schedule_slots"];
                      });
                      savedSlots.forEach((day, value) {
                        selectedDays.add(day.toString().toLowerCase());

                        generatedSlots[day.toString().toLowerCase()] = value;
                      });

                      log("$savedSlots SAVEDSLOT");
                      log("$selectedDays SELECTEDDAYS");
                      log("$generatedSlots GENERATEDSLOTS");
                    }
                  });
                }
              }))
          .whenComplete(
              () => Future.delayed(const Duration(seconds: 3), () async {
                    if (mounted) {
                      setState(() {
                        isWeekDaysLoading = false;
                        Get.find<GetAppoinmentSchedulesController>()
                            .updateAppointmentSchedulesLoader(true);
                      });
                    }
                    log("$newTime NewTime");
                    log("$intervalMinutes IntervalMinutes");
                  }));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool selectedDaysContains(String? day) {
    return selectedDays.contains(day) == true ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GenerateScheduleSlotsController>(
        builder: (generateScheduleSlotsController) {
      return GetBuilder<GetAppoinmentSchedulesController>(
          builder: (getAppoinmentSchedulesController) {
        return Container(
          child: getAppoinmentSchedulesController.getAppointmentSchedulesLoader
              ? SingleChildScrollView(
                  child: isSingleDayOn == false
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Get.find<GetAppoinmentSchedulesController>()
                                        .getAppointmentSchedulesModel
                                        .data ==
                                    null
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        18.w, 16.h, 18.w, 0),
                                    child: isWeekDaysLoading == false
                                        ? ListView.builder(
                                            itemCount: 1,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return SelectWeekDays(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                days: [
                                                  DayInWeek("Sun",
                                                      dayKey: 'sunday',
                                                      isSelected:
                                                          selectedDaysContains(
                                                              "sunday"),
                                                      isDisabled:
                                                          selectedDaysContains(
                                                              "sunday")),
                                                  DayInWeek("Mon",
                                                      dayKey: 'monday',
                                                      isSelected:
                                                          selectedDaysContains(
                                                              "monday"),
                                                      isDisabled:
                                                          selectedDaysContains(
                                                              "monday")),
                                                  DayInWeek("Tue",
                                                      dayKey: 'tuesday',
                                                      isSelected:
                                                          selectedDaysContains(
                                                              "tuesday"),
                                                      isDisabled:
                                                          selectedDaysContains(
                                                              "tuesday")),
                                                  DayInWeek("Wed",
                                                      dayKey: 'wednesday',
                                                      isSelected:
                                                          selectedDaysContains(
                                                              "wednesday"),
                                                      isDisabled:
                                                          selectedDaysContains(
                                                              "wednesday")),
                                                  DayInWeek("Thu",
                                                      dayKey: 'thursday',
                                                      isSelected:
                                                          selectedDaysContains(
                                                              "thursday"),
                                                      isDisabled:
                                                          selectedDaysContains(
                                                              "thursday")),
                                                  DayInWeek("Fri",
                                                      dayKey: 'friday',
                                                      isSelected:
                                                          selectedDaysContains(
                                                              "friday"),
                                                      isDisabled:
                                                          selectedDaysContains(
                                                              "friday")),
                                                  DayInWeek("Sat",
                                                      dayKey: 'saturday',
                                                      isSelected:
                                                          selectedDaysContains(
                                                              "saturday"),
                                                      isDisabled:
                                                          selectedDaysContains(
                                                              "saturday")),
                                                ],
                                                border: false,
                                                boxDecoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  gradient:
                                                      AppColors.gradientOne,
                                                ),
                                                onSelect: (values) {
                                                  setState(() {
                                                    selectedDays = values;
                                                  });
                                                  // <== Callback to handle the selected days
                                                  print(values);
                                                  log("$selectedDays ONSelect");
                                                },
                                              );
                                            },
                                          )
                                        : Center(
                                            child: Text(
                                              LanguageConstant
                                                  .weekDaysAreLoading.tr,
                                              style:
                                                  AppTextStyles.bodyTextStyle10,
                                            ),
                                          ),
                                  )
                                : const SizedBox(),
                            Get.find<GetAppoinmentSchedulesController>()
                                        .getAppointmentSchedulesModel
                                        .data ==
                                    null
                                ? Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 16),
                                    margin: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 16),
                                    decoration: BoxDecoration(
                                      color: AppColors.tertiaryBgColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 2, 0, 14),
                                          child: Text(
                                            "${LanguageConstant.consultationFee.tr} (${Get.find<GetAllSettingsController>().getDefaultCurrencySymbol()})",
                                            style:
                                                AppTextStyles.bodyTextStyle10,
                                          ),
                                        ),
                                        Get.find<GetAllSettingsController>()
                                                    .getAllSettingsModel
                                                    .data!
                                                    .commissionType ==
                                                "commission_base"
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: TextFormFieldWidget(
                                                      hintText:
                                                          '${LanguageConstant.enterFeesIn.tr} ${Get.find<GetAllSettingsController>().getDefaultCurrencySymbol()}',
                                                      validator: (value) {
                                                        if ((value ?? "")
                                                            .isEmpty) {
                                                          return LanguageConstant
                                                              .feeIsRequired.tr;
                                                        }
                                                        return null;
                                                      },
                                                      controller: Get.find<
                                                              GenerateScheduleSlotsController>()
                                                          .audioCallFeeController,
                                                      onChanged: (value) {
                                                        if (Get.find<
                                                                    GetAppoinmentCommissionController>()
                                                                .getAppointmentCommissionModel
                                                                .data!
                                                                .commissionType ==
                                                            "fixed_rate") {
                                                          setState(() {
                                                            totalFee = int.parse(Get
                                                                        .find<
                                                                            GenerateScheduleSlotsController>()
                                                                    .audioCallFeeController
                                                                    .text) +
                                                                Get.find<
                                                                        GetAppoinmentCommissionController>()
                                                                    .getAppointmentCommissionModel
                                                                    .data!
                                                                    .rate!;
                                                          });
                                                        } else if (Get.find<
                                                                    GetAppoinmentCommissionController>()
                                                                .getAppointmentCommissionModel
                                                                .data!
                                                                .commissionType ==
                                                            "percentage") {
                                                          setState(() {
                                                            totalFee = int.parse(Get
                                                                        .find<
                                                                            GenerateScheduleSlotsController>()
                                                                    .audioCallFeeController
                                                                    .text) +
                                                                int.parse(Get.find<
                                                                            GenerateScheduleSlotsController>()
                                                                        .audioCallFeeController
                                                                        .text) /
                                                                    100 *
                                                                    Get.find<
                                                                            GetAppoinmentCommissionController>()
                                                                        .getAppointmentCommissionModel
                                                                        .data!
                                                                        .rate!;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    "+",
                                                    style: AppTextStyles
                                                        .bodyTextStyle10,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            16.w,
                                                            12.h,
                                                            16.w,
                                                            12.h),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: AppColors
                                                                .black)),
                                                    child: Text(
                                                      Get.find<GetAppoinmentCommissionController>()
                                                                  .getAppointmentCommissionModel
                                                                  .data!
                                                                  .commissionType ==
                                                              "percentage"
                                                          ? "${Get.find<GetAppoinmentCommissionController>().getAppointmentCommissionModel.data!.rate} %"
                                                          : "${Get.find<GetAppoinmentCommissionController>().getAppointmentCommissionModel.data!.rate}",
                                                      style: AppTextStyles
                                                          .hintTextStyle1,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    "=",
                                                    style: AppTextStyles
                                                        .bodyTextStyle10,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            16.w,
                                                            12.h,
                                                            16.w,
                                                            12.h),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: AppColors
                                                                .black)),
                                                    child: Text(
                                                      totalFee
                                                              .toString()
                                                              .isEmpty
                                                          ? LanguageConstant
                                                              .total.tr
                                                          : totalFee.toString(),
                                                      style: AppTextStyles
                                                          .hintTextStyle1,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Get.find<GetAllSettingsController>()
                                                        .getAllSettingsModel
                                                        .data!
                                                        .commissionType ==
                                                    "subscription_base"
                                                ? TextFormFieldWidget(
                                                    hintText:
                                                        '${LanguageConstant.enterFeesIn.tr} ${Get.find<GetAllSettingsController>().getDefaultCurrencySymbol()}',
                                                    validator: (value) {
                                                      if ((value ?? "")
                                                          .isEmpty) {
                                                        return LanguageConstant
                                                            .feeIsRequired.tr;
                                                      }
                                                      return null;
                                                    },
                                                    controller: Get.find<
                                                            GenerateScheduleSlotsController>()
                                                        .audioCallFeeController,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        totalFee = int.parse(Get
                                                                .find<
                                                                    GenerateScheduleSlotsController>()
                                                            .audioCallFeeController
                                                            .text);
                                                      });
                                                    },
                                                  )
                                                : const SizedBox(),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            Get.find<GetAppoinmentSchedulesController>()
                                        .getAppointmentSchedulesModel
                                        .data ==
                                    null
                                ? Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 16),
                                    margin:
                                        const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                    decoration: BoxDecoration(
                                      color: AppColors.tertiaryBgColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 2, 0, 14),
                                          child: Text(
                                            LanguageConstant
                                                .generateTimeSlots.tr,
                                            style:
                                                AppTextStyles.bodyTextStyle10,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: selectStartTime,
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    16.w, 12.h, 16.w, 12.h),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color:
                                                            AppColors.black)),
                                                child: startTime == null
                                                    ? Text(
                                                        LanguageConstant
                                                            .startTime.tr,
                                                        style: AppTextStyles
                                                            .hintTextStyle1,
                                                      )
                                                    : Text(
                                                        startTime!
                                                            .format(context),
                                                        style: AppTextStyles
                                                            .hintTextStyle1,
                                                      ),
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            GestureDetector(
                                              onTap: selectEndTime,
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    16.w, 12.h, 16.w, 12.h),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color:
                                                            AppColors.black)),
                                                child: endTime == null
                                                    ? Text(
                                                        LanguageConstant
                                                            .endTime.tr,
                                                        style: AppTextStyles
                                                            .hintTextStyle1,
                                                      )
                                                    : Text(
                                                        endTime!
                                                            .format(context),
                                                        style: AppTextStyles
                                                            .hintTextStyle1,
                                                      ),
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: TextFormFieldWidget(
                                                hintText: LanguageConstant
                                                    .interval.tr,
                                                validator: (value) {
                                                  if ((value ?? "").isEmpty) {
                                                    return LanguageConstant
                                                        .intervalIsRequired.tr;
                                                  }
                                                  return null;
                                                },
                                                controller:
                                                    generateScheduleSlotsController
                                                        .audioCallIntervalController,
                                                onChanged: (value) {
                                                  intervalMinutes = int.parse(
                                                      generateScheduleSlotsController
                                                          .audioCallIntervalController
                                                          .text);
                                                  generateScheduleSlotsController
                                                      .update();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 14.h),
                                        ButtonWidgetOne(
                                          onTap: () {
                                            if (selectedDays.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(Get.find<
                                                          GeneralController>()
                                                      .showSnackBar(
                                                          LanguageConstant
                                                              .pleaseSelectDay
                                                              .tr));
                                            } else {
                                              generateSlots();
                                            }
                                          },
                                          buttonText:
                                              LanguageConstant.generate.tr,
                                          buttonTextStyle:
                                              AppTextStyles.buttonTextStyle1,
                                          borderRadius: 10,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            Padding(
                              padding: EdgeInsets.only(left: 16.w, top: 18.h),
                              child: Text(
                                generatedSlots.isEmpty
                                    ? ""
                                    : "${LanguageConstant.yourGeneratedSlots.tr} :",
                                textAlign: TextAlign.left,
                                style: AppTextStyles.headingTextStyle4,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            generatedSlots.isNotEmpty
                                ? isGenerating == false
                                    ? Wrap(
                                        children: [
                                          ListView.builder(
                                              itemCount: weekDays.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                final day =
                                                    weekDays.elementAt(index);
                                                final slots = generatedSlots[
                                                    weekDays[index]];
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              16.w,
                                                              0,
                                                              16.w,
                                                              16.h),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              weekDays[index]
                                                                  .toString()
                                                                  .capitalizeFirst!,
                                                              style: AppTextStyles
                                                                  .headingTextStyle4),
                                                          Get.find<GetAppoinmentSchedulesController>()
                                                                      .getAppointmentSchedulesModel
                                                                      .data !=
                                                                  null
                                                              ? generatedSlots
                                                                      .containsKey(
                                                                          day)
                                                                  ? ButtonWidgetFive(
                                                                      onTap:
                                                                          () {
                                                                        postMethod(
                                                                            context,
                                                                            deleteAppointmentScheduleSlotsUrl,
                                                                            {
                                                                              "appointment_type_id": 1,
                                                                              "day": day
                                                                            },
                                                                            true,
                                                                            deleteAppointmentScheduleRepo);
                                                                      },
                                                                      buttonIcon:
                                                                          Icons
                                                                              .delete,
                                                                      buttonTextStyle:
                                                                          AppTextStyles
                                                                              .buttonTextStyle2,
                                                                      borderRadius:
                                                                          8,
                                                                      iconSize:
                                                                          18,
                                                                    )
                                                                  : ButtonWidgetOne(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          selectedDay =
                                                                              weekDays[index];
                                                                          isSingleDayOn =
                                                                              true;
                                                                        });
                                                                      },
                                                                      buttonText:
                                                                          LanguageConstant
                                                                              .add
                                                                              .tr,
                                                                      buttonTextStyle:
                                                                          AppTextStyles
                                                                              .buttonTextStyle2,
                                                                      borderRadius:
                                                                          8,
                                                                    )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                    ),
                                                    generatedSlots
                                                            .containsKey(day)
                                                        ? GridView.builder(
                                                            itemCount:
                                                                slots!.length,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    16,
                                                                    0,
                                                                    16,
                                                                    24),
                                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                childAspectRatio:
                                                                    2 / 0.8,
                                                                crossAxisCount:
                                                                    3,
                                                                crossAxisSpacing:
                                                                    6,
                                                                mainAxisSpacing:
                                                                    6),
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int slotIndex) {
                                                              final slot = slots[
                                                                  slotIndex];
                                                              final startTime =
                                                                  slot[
                                                                      'start_time'];
                                                              final endTime =
                                                                  slot[
                                                                      'end_time'];

                                                              return Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        gradient:
                                                                            AppColors
                                                                                .gradientTwo,
                                                                        border: Border
                                                                            .all(
                                                                          color:
                                                                              AppColors.black,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8)),
                                                                child: Theme(
                                                                  data: Theme.of(context).copyWith(
                                                                      splashColor:
                                                                          AppColors
                                                                              .transparent,
                                                                      highlightColor:
                                                                          AppColors
                                                                              .transparent,
                                                                      canvasColor:
                                                                          AppColors
                                                                              .transparent),
                                                                  child:
                                                                      ChoiceChip(
                                                                    visualDensity: const VisualDensity(
                                                                        horizontal:
                                                                            -1,
                                                                        vertical:
                                                                            -4),
                                                                    label: Text(
                                                                        "$startTime - $endTime"),
                                                                    labelStyle:
                                                                        AppTextStyles
                                                                            .chipsTextStyle1,

                                                                    // labelStyle: value == slotIndex
                                                                    //     ? AppTextStyles
                                                                    //         .chipsTextStyle2
                                                                    //     : AppTextStyles
                                                                    //         .chipsTextStyle1,
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .transparent,
                                                                    selectedColor:
                                                                        AppColors
                                                                            .transparent,
                                                                    disabledColor:
                                                                        AppColors
                                                                            .transparent,
                                                                    surfaceTintColor:
                                                                        AppColors
                                                                            .tertiaryBgColor,
                                                                    selected:
                                                                        value ==
                                                                            slotIndex,
                                                                    showCheckmark:
                                                                        false,
                                                                    side: const BorderSide(
                                                                        color: AppColors
                                                                            .transparent),
                                                                    // onSelected:
                                                                    //     (bool selected) {
                                                                    //   setState(() {
                                                                    //     value = selected
                                                                    //         ? slotIndex
                                                                    //         : null;
                                                                    //   });
                                                                    // },
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    16.w,
                                                                    0,
                                                                    16.w,
                                                                    16.h),
                                                            child: Center(
                                                              child: Text(
                                                                  LanguageConstant
                                                                      .holiday
                                                                      .tr,
                                                                  style: AppTextStyles
                                                                      .bodyTextStyle12),
                                                            ),
                                                          )
                                                  ],
                                                );
                                              }),
                                        ],
                                      )
                                    : CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                      )
                                : const SizedBox(),
                            Get.find<GetAppoinmentSchedulesController>()
                                        .getAppointmentSchedulesModel
                                        .data ==
                                    null
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        16.w, 0, 16.w, 16.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ButtonWidgetOne(
                                              onTap: () {
                                                if (selectedDays.isNotEmpty &&
                                                    startTime != null &&
                                                    endTime != null) {
                                                  postMethod(
                                                      context,
                                                      generateAppointmentScheduleSlotsUrl,
                                                      {
                                                        "appointment_type_id":
                                                            2,
                                                        "is_schedule_required":
                                                            1,
                                                        "selected_days":
                                                            selectedDays,
                                                        "start_time": startTime!
                                                            .format(context),
                                                        "end_time": endTime!
                                                            .format(context),
                                                        "fee": generateScheduleSlotsController
                                                            .audioCallFeeController
                                                            .text,
                                                        "interval":
                                                            generateScheduleSlotsController
                                                                .audioCallIntervalController
                                                                .text,
                                                        "generated_slots":
                                                            generatedSlots,
                                                      },
                                                      true,
                                                      generateAppointmentScheduleSlotsRepo);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(Get.find<
                                                              GeneralController>()
                                                          .showSnackBar(
                                                              LanguageConstant
                                                                  .pleaseSelectDayStartTimeandEndTime
                                                                  .tr));
                                                }
                                              },
                                              buttonText:
                                                  LanguageConstant.save.tr,
                                              buttonTextStyle: AppTextStyles
                                                  .buttonTextStyle1,
                                              borderRadius: 10,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 18.w),
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ButtonWidgetOne(
                                              onTap: () {},
                                              buttonText:
                                                  LanguageConstant.reset.tr,
                                              buttonTextStyle: AppTextStyles
                                                  .buttonTextStyle1,
                                              borderRadius: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        )
                      : addTimeSlotsForSingleDay(),
                )
              : Center(
                  child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                )),
        );
      });
    });
  }

  Widget addTimeSlotsForSingleDay() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          margin: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: AppColors.tertiaryBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 14),
                child: Text(
                  "${LanguageConstant.consultationFee.tr} (${Get.find<GetAllSettingsController>().getDefaultCurrencySymbol()})",
                  style: AppTextStyles.bodyTextStyle10,
                ),
              ),
              Get.find<GetAllSettingsController>()
                          .getAllSettingsModel
                          .data!
                          .commissionType ==
                      "commission_base"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormFieldWidget(
                            hintText:
                                '${LanguageConstant.enterFeesIn.tr} ${Get.find<GetAllSettingsController>().getDefaultCurrencySymbol()}',
                            validator: (value) {
                              if ((value ?? "").isEmpty) {
                                return LanguageConstant.feeIsRequired.tr;
                              }
                              return null;
                            },
                            controller:
                                Get.find<GenerateScheduleSlotsController>()
                                    .forSingleDayAudioCallFeeController,
                            onChanged: (value) {
                              if (Get.find<GetAppoinmentCommissionController>()
                                      .getAppointmentCommissionModel
                                      .data!
                                      .commissionType ==
                                  "fixed_rate") {
                                setState(() {
                                  totalFeeForSingleDay = int.parse(Get.find<
                                              GenerateScheduleSlotsController>()
                                          .forSingleDayAudioCallFeeController
                                          .text) +
                                      Get.find<
                                              GetAppoinmentCommissionController>()
                                          .getAppointmentCommissionModel
                                          .data!
                                          .rate!;
                                });
                              } else if (Get.find<
                                          GetAppoinmentCommissionController>()
                                      .getAppointmentCommissionModel
                                      .data!
                                      .commissionType ==
                                  "percentage") {
                                setState(() {
                                  totalFeeForSingleDay = int.parse(Get.find<
                                              GenerateScheduleSlotsController>()
                                          .forSingleDayAudioCallFeeController
                                          .text) +
                                      int.parse(Get.find<
                                                  GenerateScheduleSlotsController>()
                                              .forSingleDayAudioCallFeeController
                                              .text) /
                                          100 *
                                          Get.find<
                                                  GetAppoinmentCommissionController>()
                                              .getAppointmentCommissionModel
                                              .data!
                                              .rate!;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "+",
                          style: AppTextStyles.bodyTextStyle10,
                        ),
                        SizedBox(width: 4.w),
                        Container(
                          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.black)),
                          child: Text(
                            Get.find<GetAppoinmentCommissionController>()
                                        .getAppointmentCommissionModel
                                        .data!
                                        .commissionType ==
                                    "percentage"
                                ? "${Get.find<GetAppoinmentCommissionController>().getAppointmentCommissionModel.data!.rate} %"
                                : "${Get.find<GetAppoinmentCommissionController>().getAppointmentCommissionModel.data!.rate}",
                            style: AppTextStyles.hintTextStyle1,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "=",
                          style: AppTextStyles.bodyTextStyle10,
                        ),
                        SizedBox(width: 4.w),
                        Container(
                          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.black)),
                          child: Text(
                            totalFeeForSingleDay.toString().isEmpty
                                ? LanguageConstant.total.tr
                                : totalFeeForSingleDay.toString(),
                            style: AppTextStyles.hintTextStyle1,
                          ),
                        ),
                      ],
                    )
                  : Get.find<GetAllSettingsController>()
                              .getAllSettingsModel
                              .data!
                              .commissionType ==
                          "subscription_base"
                      ? TextFormFieldWidget(
                          hintText:
                              '${LanguageConstant.enterFeesIn.tr} ${Get.find<GetAllSettingsController>().getDefaultCurrencySymbol()}',
                          validator: (value) {
                            if ((value ?? "").isEmpty) {
                              return LanguageConstant.feeIsRequired.tr;
                            }
                            return null;
                          },
                          controller:
                              Get.find<GenerateScheduleSlotsController>()
                                  .forSingleDayAudioCallFeeController,
                          onChanged: (value) {
                            setState(() {
                              totalFeeForSingleDay = int.parse(
                                  Get.find<GenerateScheduleSlotsController>()
                                      .forSingleDayAudioCallFeeController
                                      .text);
                            });
                          },
                        )
                      : const SizedBox(),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 16.h),
          margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 24.h),
          decoration: BoxDecoration(
            color: AppColors.tertiaryBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 14),
                child: Text(
                  LanguageConstant.generateTimeSlots.tr,
                  style: AppTextStyles.bodyTextStyle10,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: forSingleDaySelectStartTime,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.black)),
                      child: forSingleDayStartTime == null
                          ? Text(
                              LanguageConstant.startTime.tr,
                              style: AppTextStyles.hintTextStyle1,
                            )
                          : Text(
                              forSingleDayStartTime!.format(context),
                              style: AppTextStyles.hintTextStyle1,
                            ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: forSingleDaySelectEndTime,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.black)),
                      child: forSingleDayEndTime == null
                          ? Text(
                              LanguageConstant.endTime.tr,
                              style: AppTextStyles.hintTextStyle1,
                            )
                          : Text(
                              forSingleDayEndTime!.format(context),
                              style: AppTextStyles.hintTextStyle1,
                            ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextFormFieldWidget(
                      hintText: LanguageConstant.interval.tr,
                      validator: (value) {
                        if ((value ?? "").isEmpty) {
                          return LanguageConstant.intervalIsRequired.tr;
                        }
                        return null;
                      },
                      controller: Get.find<GenerateScheduleSlotsController>()
                          .forSingleDayAudioCallIntervalController,
                      onChanged: (value) {
                        intervalMinutes = int.parse(
                            Get.find<GenerateScheduleSlotsController>()
                                .forSingleDayAudioCallIntervalController
                                .text);
                        Get.find<GenerateScheduleSlotsController>().update();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 24.h),
          child: ButtonWidgetOne(
            onTap: () {
              if (selectedDay.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    Get.find<GeneralController>()
                        .showSnackBar(LanguageConstant.pleaseSelectDay.tr));
              } else {
                forSingleDayGenerateSlots();
              }
            },
            buttonText: LanguageConstant.generate.tr,
            buttonTextStyle: AppTextStyles.bodyTextStyle8,
            borderRadius: 10,
          ),
        ),
        isGenerating == false
            ? Wrap(
                children: [
                  ListView.builder(
                      itemCount: singleDayGeneratedSlots.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final day = weekDays.elementAt(index);
                        final slots = singleDayGeneratedSlots[day];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(day.toString().capitalizeFirst!,
                                      style: AppTextStyles.headingTextStyle4),
                                ],
                              ),
                            ),
                            GridView.builder(
                              itemCount: slots!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 2 / 0.8,
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 6,
                                      mainAxisSpacing: 6),
                              itemBuilder:
                                  (BuildContext context, int slotIndex) {
                                final slot = slots[slotIndex];
                                final startTime = slot['start_time'];
                                final endTime = slot['end_time'];

                                return Container(
                                  decoration: BoxDecoration(
                                      gradient: AppColors.gradientTwo,
                                      border: Border.all(
                                        color: AppColors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                        splashColor: AppColors.transparent,
                                        highlightColor: AppColors.transparent,
                                        canvasColor: AppColors.transparent),
                                    child: ChoiceChip(
                                      visualDensity: const VisualDensity(
                                          horizontal: -1, vertical: -4),
                                      label: Text("$startTime - $endTime"),
                                      labelStyle: AppTextStyles.chipsTextStyle1,

                                      // labelStyle: value == slotIndex
                                      //     ? AppTextStyles
                                      //         .chipsTextStyle2
                                      //     : AppTextStyles
                                      //         .chipsTextStyle1,
                                      backgroundColor: AppColors.transparent,
                                      selectedColor: AppColors.transparent,
                                      disabledColor: AppColors.transparent,
                                      surfaceTintColor:
                                          AppColors.tertiaryBgColor,
                                      selected: value == slotIndex,
                                      showCheckmark: false,
                                      side: const BorderSide(
                                          color: AppColors.transparent),
                                      // onSelected:
                                      //     (bool selected) {
                                      //   setState(() {
                                      //     value = selected
                                      //         ? slotIndex
                                      //         : null;
                                      //   });
                                      // },
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        );
                      }),
                ],
              )
            : CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ButtonWidgetOne(
                    onTap: () {
                      if (selectedDay.isNotEmpty &&
                          forSingleDayStartTime != null &&
                          forSingleDayEndTime != null) {
                        postMethod(
                            context,
                            generateAppointmentScheduleSlotsForSingleDayUrl,
                            {
                              "appointment_type_id": 2,
                              "day": selectedDay,
                              "start_time":
                                  forSingleDayStartTime!.format(context),
                              "end_time": forSingleDayEndTime!.format(context),
                              "fee": Get.find<GenerateScheduleSlotsController>()
                                  .forSingleDayAudioCallFeeController
                                  .text,
                              "interval":
                                  Get.find<GenerateScheduleSlotsController>()
                                      .forSingleDayAudioCallIntervalController
                                      .text,
                              "generated_slots": singleDayGeneratedSlots,
                            },
                            true,
                            generateAppointmentScheduleSlotsForSingleDayRepo);
                        Get.offNamed(PageRoutes.scheduleAppSlots);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            Get.find<GeneralController>().showSnackBar(
                                LanguageConstant
                                    .pleaseSelectDayStartTimeandEndTime.tr));
                      }
                    },
                    buttonText: LanguageConstant.save.tr,
                    buttonTextStyle: AppTextStyles.bodyTextStyle8,
                    borderRadius: 10,
                  ),
                ),
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ButtonWidgetOne(
                    onTap: () {
                      setState(() {
                        isSingleDayOn = false;
                      });
                    },
                    buttonText: LanguageConstant.reset.tr,
                    buttonTextStyle: AppTextStyles.bodyTextStyle8,
                    borderRadius: 10,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
