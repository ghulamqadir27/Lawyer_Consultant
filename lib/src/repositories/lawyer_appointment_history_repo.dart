import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lawyer_appointment_history_controller.dart';
import '../controllers/general_controller.dart';
import '../models/lawyer_appointment_history_model.dart';

void getAllLawyerAppointmentHistoryRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<LawyerAppointmentHistoryController>()
        .lawyerAllAppointmentHistoryListForPagination
        .isNotEmpty) {
      Get.find<LawyerAppointmentHistoryController>()
          .lawyerAllAppointmentHistoryListForPagination = [];
    }
    Get.find<LawyerAppointmentHistoryController>()
            .getLawyerAppointmentHistoryModel =
        GetLawyerAppointmentHistoryModel.fromJson(response);

    Get.find<LawyerAppointmentHistoryController>()
        .updateLawyerAppointmentHistoryLoader(true);
    log("${Get.find<LawyerAppointmentHistoryController>().getLawyerAppointmentHistoryModel.data!.data!.length.toString()} Total Lawyer Appoinment History Length");
    log("${Get.find<LawyerAppointmentHistoryController>().getLawyerAppointmentHistoryModel.data!.data!.where((i) => i.appointmentStatusName == "Completed").toList().length.toString()} Total Completed Lawyer Appoinment History Length");
    log("${Get.find<LawyerAppointmentHistoryController>().getLawyerAppointmentHistoryModel.data!.data!} Only Data Lawyer Appoinment History");

    for (var element in Get.find<LawyerAppointmentHistoryController>()
        .getLawyerAppointmentHistoryModel
        .data!
        .data!) {
      Get.find<LawyerAppointmentHistoryController>()
          .updateLawyerListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);
  } else if (!responseCheck) {
    Get.find<LawyerAppointmentHistoryController>()
        .updateLawyerAppointmentHistoryLoader(true);
  }
}
