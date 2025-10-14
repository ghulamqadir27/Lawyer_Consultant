import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/get_lawyer_profile_service_model.dart';
import '../models/get_lawyer_profile_certificate_model.dart';
import '../models/get_lawyer_profile_education_model.dart';
import '../models/get_lawyer_profile_experience_model.dart';
import '../models/get_lawyer_profile_podcast_model.dart';
import '../models/get_lawyer_service_categories_model.dart';
import 'general_controller.dart';

class EditProfileController extends GetxController {
  GetLawyerProfileCertificateModel getLawyerProfileCertificateModel =
      GetLawyerProfileCertificateModel(); //  for saving User Certificate Profile
  GetLawyerProfileExperienceModel getLawyerProfileExperienceModel =
      GetLawyerProfileExperienceModel(); //  for saving User Experience Profile
  GetLawyerProfileEducationModel getLawyerProfileEducationModel =
      GetLawyerProfileEducationModel(); //  for saving User Education Profile
  GetLawyerProfilePodcastModel getLawyerProfilePodcastModel =
      GetLawyerProfilePodcastModel(); //  for saving User Podcast Profile
  GetLawyerProfileServiceModel getLawyerProfileServiceModel =
      GetLawyerProfileServiceModel(); //  for saving User Service Profile
  LawyerProfileCertificateModel lawyerProfileCertificateModel =
      LawyerProfileCertificateModel(); //  for saving User Certificate Profile
  LawyerProfileExperienceModel lawyerProfileExperienceModel =
      LawyerProfileExperienceModel(); //  for saving User Experience Profile
  LawyerProfileEducationModel lawyerProfileEducationModel =
      LawyerProfileEducationModel(); //  for saving User Education Profile
  LawyerProfilePodcastModel lawyerProfilePodcastModel =
      LawyerProfilePodcastModel(); //  for saving User Podcast Profile
  LawyerProfileServiceModel lawyerProfileServiceModel =
      LawyerProfileServiceModel(); //  for saving User Service Profile
  GetLawyerServiceCategoriesModel getLawyerServiceCategoriesModel =
      GetLawyerServiceCategoriesModel(); //  for Getting User Service Categories

  // Basic Information Controllers
  TextEditingController userProfileFirstNameController =
      TextEditingController();
  TextEditingController userProfileLastNameController = TextEditingController();

  TextEditingController userProfileUserNameController = TextEditingController();
  TextEditingController userProfileDescriptionController =
      TextEditingController();
  TextEditingController userProfileAddressLine1Controller =
      TextEditingController();
  TextEditingController userProfileAddressLine2Controller =
      TextEditingController();
  TextEditingController userProfileZipCodeController = TextEditingController();

  // Education Controllers
  TextEditingController educationInstituteNameController =
      TextEditingController();
  TextEditingController educationDescriptionController =
      TextEditingController();
  TextEditingController educationDegreeController = TextEditingController();
  TextEditingController educationSubjectController = TextEditingController();
  TextEditingController educationStartDateController = TextEditingController();
  TextEditingController educationEndDateController = TextEditingController();

  // Certificate Controllers
  TextEditingController certificateNameController = TextEditingController();
  TextEditingController certificateDescriptionController =
      TextEditingController();
  TextEditingController certificateFileController = TextEditingController();

  // Experience Controllers
  TextEditingController experienceCompanyNameController =
      TextEditingController();
  TextEditingController experienceDescriptionController =
      TextEditingController();
  TextEditingController experienceStartDateController = TextEditingController();
  TextEditingController experienceEndDateController = TextEditingController();

  // Podcast Controllers
  TextEditingController podcastNameController = TextEditingController();
  TextEditingController podcastDescriptionController = TextEditingController();
  TextEditingController podcastFileTypeController = TextEditingController();
  TextEditingController podcastLinkTypeController = TextEditingController();
  TextEditingController podcastCategoryController = TextEditingController();
  TextEditingController podcastTagController = TextEditingController();
  TextEditingController podcastFileURLController = TextEditingController();

  // Service Controllers
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController serviceDescriptionController = TextEditingController();
  TextEditingController serviceCategoryController = TextEditingController();
  TextEditingController serviceTagController = TextEditingController();
  TextEditingController serviceFileURLController = TextEditingController();
  TextEditingController servicePriceController = TextEditingController();

  String? userProfileSelectedGender;
  DateTime? userProfileSelectedDate;

  File? profileImage;
  String? uploadedProfileImage;
  List profileImagesList = [];

  List<LawyerProfileCertificateModel> lawyerProfileCertificateForPagination =
      [];
  List<LawyerProfileExperienceModel> lawyerProfileExperienceForPagination = [];
  List<LawyerProfileEducationModel> lawyerProfileEducationForPagination = [];
  List<LawyerProfilePodcastModel> lawyerProfilePodcastForPagination = [];
  List<LawyerProfileServiceModel> lawyerProfileServiceForPagination = [];

  bool allLawyerCertificateLoader = false;
  updateLawyerCertificateLoader(bool newValue) {
    allLawyerCertificateLoader = newValue;
    update();
  }

  bool allLawyerExperienceLoader = false;
  updateLawyerExperienceLoader(bool newValue) {
    allLawyerExperienceLoader = newValue;
    update();
  }

  bool allLawyerEducationLoader = false;
  updateLawyerEducationLoader(bool newValue) {
    allLawyerEducationLoader = newValue;
    update();
  }

  bool allLawyerPodcastLoader = false;
  updateLawyerPodcastLoader(bool newValue) {
    allLawyerPodcastLoader = newValue;
    update();
  }

  bool allLawyerServiceLoader = false;
  updateLawyerServiceLoader(bool newValue) {
    allLawyerServiceLoader = newValue;
    update();
  }

  ///------------------------------- Lawyer-Certificate-data-check
  bool getLawyerCertificateCheck = false;
  getLawyerCertificateDataCheck(bool value) {
    getLawyerCertificateCheck = value;
    update();
  }

  ///------------------------------- Lawyer-Experience-data-check
  bool getLawyerExperienceCheck = false;
  getLawyerExperienceDataCheck(bool value) {
    getLawyerExperienceCheck = value;
    update();
  }

  ///------------------------------- Lawyer-Education-data-check
  bool getLawyerEducationCheck = false;
  getLawyerEducationDataCheck(bool value) {
    getLawyerEducationCheck = value;
    update();
  }

  ///------------------------------- Lawyer-Podcast-data-check
  bool getLawyerPodcastCheck = false;
  getLawyerPodcastDataCheck(bool value) {
    getLawyerPodcastCheck = value;
    update();
  }

  ///------------------------------- Lawyer-Service-data-check
  bool getLawyerServiceCheck = false;
  getLawyerServiceDataCheck(bool value) {
    getLawyerServiceCheck = value;
    update();
  }

  int? selectedLawyerCertificateIndex = 0;
  updateSelectedLawyerCertificateIndex(int? newValue) {
    selectedLawyerCertificateIndex = newValue;
    update();
  }

  int? selectedLawyerExperienceIndex = 0;
  updateSelectedLawyerExperienceIndex(int? newValue) {
    selectedLawyerExperienceIndex = newValue;
    update();
  }

  int? selectedLawyerEducationIndex = 0;
  updateSelectedLawyerEducationIndex(int? newValue) {
    selectedLawyerEducationIndex = newValue;
    update();
  }

  int? selectedLawyerPodcastIndex = 0;
  updateSelectedLawyerPodcastIndex(int? newValue) {
    selectedLawyerPodcastIndex = newValue;
    update();
  }

  int? selectedLawyerServiceIndex = 0;
  updateSelectedLawyerServiceIndex(int? newValue) {
    selectedLawyerServiceIndex = newValue;
    update();
  }

  /// Certificate-paginated-data-fetch
  Future paginationDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getLawyerProfileCertificateModel.data!.meta!.lastPage! >
        getLawyerProfileCertificateModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      update();
    }
  }

  /// Experience-paginated-data-fetch
  Future paginationExperienceDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getLawyerProfileExperienceModel.data!.meta!.lastPage! >
        getLawyerProfileExperienceModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      update();
    }
  }

  /// Education-paginated-data-fetch
  Future paginationEducationDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getLawyerProfileEducationModel.data!.meta!.lastPage! >
        getLawyerProfileEducationModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      update();
    }
  }

  /// Podcast-paginated-data-fetch
  Future paginationPodcastDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getLawyerProfilePodcastModel.data!.meta!.lastPage! >
        getLawyerProfilePodcastModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      update();
    }
  }

  /// Service-paginated-data-fetch
  Future paginationServiceDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getLawyerProfileServiceModel.data!.meta!.lastPage! >
        getLawyerProfileServiceModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      update();
    }
  }

  updateLawyerCertificateForPagination(
      LawyerProfileCertificateModel lawyerProfileCertificateModel) {
    lawyerProfileCertificateForPagination.add(lawyerProfileCertificateModel);
    update();
  }

  updateLawyerExperienceForPagination(
      LawyerProfileExperienceModel lawyerProfileExperienceModel) {
    lawyerProfileExperienceForPagination.add(lawyerProfileExperienceModel);
    update();
  }

  updateLawyerEducationForPagination(
      LawyerProfileEducationModel lawyerProfileEducationModel) {
    lawyerProfileEducationForPagination.add(lawyerProfileEducationModel);
    update();
  }

  updateLawyerPodcastForPagination(
      LawyerProfilePodcastModel lawyerProfilePodcastModel) {
    lawyerProfilePodcastForPagination.add(lawyerProfilePodcastModel);
    update();
  }

  updateLawyerServiceForPagination(
      LawyerProfileServiceModel lawyerProfileServiceModel) {
    lawyerProfileServiceForPagination.add(lawyerProfileServiceModel);
    update();
  }

  ///------------------------------- user-profile-data-check
  bool getUserProfileDataCheck = false;

  changeGetUserProfileDataCheck(bool value) {
    getUserProfileDataCheck = value;
    update();
  }
}
