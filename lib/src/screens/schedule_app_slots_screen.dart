import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lawyer_consultant_for_lawyers/src/widgets/chat_appointment_slots_widget.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/appoinment_commission_controller.dart';
import '../controllers/appoinment_schedules_controller.dart';

import '../controllers/generate_schedule_slots_controller.dart';

import '../widgets/appbar_widget.dart';
import '../widgets/audio_call_appointment_slots_widget.dart';

import '../widgets/video_call_appointment_slots_widget.dart';

class ScheduleAppSlotsScreen extends StatefulWidget {
  const ScheduleAppSlotsScreen({super.key});

  @override
  State<ScheduleAppSlotsScreen> createState() => _ScheduleAppSlotsScreenState();
}

class _ScheduleAppSlotsScreenState extends State<ScheduleAppSlotsScreen> {
  final logic = Get.put(GenerateScheduleSlotsController());
  final appointmentSchedulelogic = Get.put(GetAppoinmentSchedulesController());
  final appointmentCommissionlogic =
      Get.put(GetAppoinmentCommissionController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GenerateScheduleSlotsController>(
        builder: (generateScheduleSlotsController) {
      return GetBuilder<GetAppoinmentSchedulesController>(
          builder: (getAppoinmentSchedulesController) {
        return DefaultTabController(
          length: 3, // length of tabs
          initialIndex: 0,
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBarWidget(
                richTextSpan: TextSpan(
                  text: LanguageConstant.appointmentSlots.tr,
                  style: AppTextStyles.appbarTextStyle2,
                  children: const <TextSpan>[],
                ),
                leadingIcon: "assets/icons/Expand_left.png",
                leadingOnTap: () {
                  Get.back();
                },
              ),
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TabBar(
                    labelColor: AppColors.white,

                    unselectedLabelColor: AppColors.black,
                    // dividerColor: AppColors.primaryColor,
                    padding: const EdgeInsets.fromLTRB(3, 6, 3, 6),
                    indicatorPadding: const EdgeInsets.fromLTRB(3, 4, 3, 4),
                    labelPadding: EdgeInsets.zero,
                    labelStyle: AppTextStyles.buttonTextStyle2,
                    unselectedLabelStyle: AppTextStyles.buttonTextStyle7,
                    indicator: BoxDecoration(
                        gradient: AppColors.gradientOne,
                        borderRadius: BorderRadius.circular(10)),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ImageIcon(
                              AssetImage("assets/icons/🦆 icon _Video_.png"),
                            ),
                            SizedBox(width: 3.w),
                            Text(LanguageConstant.videoCall.tr),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ImageIcon(
                              AssetImage(
                                  "assets/icons/🦆 icon _Volume Up_.png"),
                            ),
                            SizedBox(width: 3.w),
                            Text(LanguageConstant.audioCall.tr),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ImageIcon(
                              AssetImage("assets/icons/🦆 icon _comments_.png"),
                            ),
                            SizedBox(width: 3.w),
                            Text(LanguageConstant.onlineChat.tr),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(),
                      // ignore: prefer_const_constructors
                      child: TabBarView(children: <Widget>[
                        // Video Call Appointment Slots
                        VideoCallAppointmentSlotsWidget(),
                        // Audio Call Appointment Slots
                        AudioCallAppointmentSlotsWidget(),
                        // Online Chat
                        ChatAppointmentSlotsWidget(),
                      ]),
                    ),
                  )
                ]),
          ),
        );
      });
    });
  }
}
