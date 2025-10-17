import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_consultant_for_lawyers/src/models/lawyer_booked_services_model.dart';
import 'package:resize/resize.dart';
import 'general_controller.dart';

class LawyerBookedServicesController extends GetxController {
  GetLawyerBookedServicesModel getLawyerBookedServicesModel =
      GetLawyerBookedServicesModel();

  bool allLawyerBookedServicesLoader = false;
  void updateLawyerBookedServicesLoader(bool newValue) {
    allLawyerBookedServicesLoader = newValue;
    update();
  }

  GetLawyerBookedServicesDataModel getLawyerBookedServicesDataModel =
      GetLawyerBookedServicesDataModel();

  List<LawyerBookedServiceModel> lawyerAllBookedServicesListForPagination = [];

  ///------------------------------- Lawyers-data-check
  bool getLawyerBookedServiceDataCheck = false;
  void getLawyerBookedServicesDataCheck(bool value) {
    getLawyerBookedServiceDataCheck = value;
    update();
  }

  int? selectedLawyerCategoryIndex = 0;
  void updateSelectedLawyerCategoryIndex(int? newValue) {
    selectedLawyerCategoryIndex = newValue;
    update();
  }

  /// paginated-data-fetch
  Future paginationDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getLawyerBookedServicesModel.data!.meta!.lastPage! >
        getLawyerBookedServicesModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      update();
    }
  }

  void updateLawyerListForPagination(
      LawyerBookedServiceModel lawyerBookedServiceModel) {
    lawyerAllBookedServicesListForPagination.add(lawyerBookedServiceModel);
    update();
  }

  ///----app-bar-settings-----start
  ScrollController? scrollController;
  bool lastStatus = true;
  double height = 100.h;

  bool get isShrink {
    return scrollController!.hasClients &&
        scrollController!.offset > (height - kToolbarHeight);
  }

  void scrollListener() {
    if (isShrink != lastStatus) {
      lastStatus = isShrink;
      update();
    }
  }
}
