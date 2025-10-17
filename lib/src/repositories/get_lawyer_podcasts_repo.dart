import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

import '../controllers/general_controller.dart';
import '../models/get_lawyer_profile_podcast_model.dart';

void getLawyerPodcastsRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<EditProfileController>()
        .lawyerProfilePodcastForPagination
        .isNotEmpty) {
      Get.find<EditProfileController>().lawyerProfilePodcastForPagination = [];
    }
    Get.find<EditProfileController>().getLawyerProfilePodcastModel =
        GetLawyerProfilePodcastModel.fromJson(response);

    Get.find<EditProfileController>().updateLawyerPodcastLoader(true);
    log("${Get.find<EditProfileController>().getLawyerProfilePodcastModel.data!.data!.length.toString()} Total Lawyer Podcast History Length");

    log("${Get.find<EditProfileController>().getLawyerProfilePodcastModel.data!.data!} Only Data Lawyer Podcast History");

    for (var element in Get.find<EditProfileController>()
        .getLawyerProfilePodcastModel
        .data!
        .data!) {
      Get.find<EditProfileController>()
          .updateLawyerPodcastForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllLawyersCategoriesController>().getAllLawyerCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<EditProfileController>().updateLawyerPodcastLoader(true);
  }
}
