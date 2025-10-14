import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/general_controller.dart';
import '../controllers/lawyer_booked_services_controller.dart';
import '../models/lawyer_booked_services_model.dart';

getAllLawyerBookedServicesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<LawyerBookedServicesController>()
        .lawyerAllBookedServicesListForPagination
        .isNotEmpty) {
      Get.find<LawyerBookedServicesController>()
          .lawyerAllBookedServicesListForPagination = [];
    }
    Get.find<LawyerBookedServicesController>().getLawyerBookedServicesModel =
        GetLawyerBookedServicesModel.fromJson(response);

    Get.find<LawyerBookedServicesController>()
        .updateLawyerBookedServicesLoader(true);
    log("${Get.find<LawyerBookedServicesController>().getLawyerBookedServicesModel.data!.data!.length.toString()} Total LawyerBooked Services Length");
    log("${Get.find<LawyerBookedServicesController>().getLawyerBookedServicesModel.data!.data!.where((i) => i.serviceStatusName == "Completed").toList().length.toString()} Total Completed LawyerBooked Services Length");
    log("${Get.find<LawyerBookedServicesController>().getLawyerBookedServicesModel.data!.data!} Only Data LawyerBooked Services");

    for (var element in Get.find<LawyerBookedServicesController>()
        .getLawyerBookedServicesModel
        .data!
        .data!) {
      Get.find<LawyerBookedServicesController>()
          .updateLawyerListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);
  } else if (!responseCheck) {
    Get.find<LawyerBookedServicesController>()
        .updateLawyerBookedServicesLoader(true);
  }
}
