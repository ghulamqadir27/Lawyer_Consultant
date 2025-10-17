import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

import '../controllers/general_controller.dart';
import '../models/get_lawyer_profile_service_model.dart';

void getLawyerServicesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<EditProfileController>()
        .lawyerProfileServiceForPagination
        .isNotEmpty) {
      Get.find<EditProfileController>().lawyerProfileServiceForPagination = [];
    }
    Get.find<EditProfileController>().getLawyerProfileServiceModel =
        GetLawyerProfileServiceModel.fromJson(response);

    Get.find<EditProfileController>().updateLawyerServiceLoader(true);
    log("${Get.find<EditProfileController>().getLawyerProfileServiceModel.data!.data!.length.toString()} Total Lawyer Service History Length");

    log("${Get.find<EditProfileController>().getLawyerProfileServiceModel.data!.data!} Only Data Lawyer Service History");

    for (var element in Get.find<EditProfileController>()
        .getLawyerProfileServiceModel
        .data!
        .data!) {
      Get.find<EditProfileController>()
          .updateLawyerServiceForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllLawyersCategoriesController>().getAllLawyerCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<EditProfileController>().updateLawyerServiceLoader(true);
  }
}
