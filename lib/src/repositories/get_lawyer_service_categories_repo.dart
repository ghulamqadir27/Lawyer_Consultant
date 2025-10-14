import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';
import '../models/get_lawyer_service_categories_model.dart';

getLawyerServiceCategoriesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<EditProfileController>().getLawyerServiceCategoriesModel =
        GetLawyerServiceCategoriesModel.fromJson(response);

    log("${Get.find<EditProfileController>().getLawyerServiceCategoriesModel.data!.length.toString()} Total Lawyer Service Categories Length");

    log("${Get.find<EditProfileController>().getLawyerServiceCategoriesModel.data!} Only Data Lawyer Service Categories");
  } else if (!responseCheck) {}
}
