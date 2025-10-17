import 'dart:developer';

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:resize/resize.dart';
import '../../multi_language/language_constants.dart';
import '../api_services/delete_service.dart';
import '../api_services/get_service.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/general_controller.dart';
import '../repositories/delete_account_repo.dart';
import '../repositories/edit_user_profile_repo.dart';

import '../repositories/get_lawyer_certificate_repo.dart';
import '../repositories/get_lawyer_education_repo.dart';
import '../repositories/get_lawyer_experience_repo.dart';
import '../repositories/get_lawyer_podcasts_repo.dart';
import '../repositories/get_lawyer_service_categories_repo.dart';
import '../repositories/get_lawyer_services_repo.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/text_form_field_widget.dart';

class LawyerProfileScreen extends StatefulWidget {
  const LawyerProfileScreen({super.key});

  @override
  State<LawyerProfileScreen> createState() => LawyerProfileScreenState();
}

class LawyerProfileScreenState extends State<LawyerProfileScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _userProfileUpdateFormKey = GlobalKey();
  final editProfileLogic = Get.put(EditProfileController());
  final generalLogic = Get.put(GeneralController());
  File? file;
  int tabsLength = 8;
  int indexPage = 0;
  TabController? tabController;
  bool isVisibleEducationForm = false;

  Future<void> filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });

      print(file!.path);
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();

    if (Get.find<GeneralController>()
        .currentLawyerModel!
        .lawyerModules!
        .contains("lawyer-events")) {
      print("FIND TRUE");
    } else {
      print("FIND NOT TRUE");
    }

    tabController = TabController(vsync: this, length: tabsLength);
    // getMethod(context, getLoggedInUserUrl, null, true, loggedInUserRepo);
    editProfileLogic.userProfileFirstNameController.text =
        generalLogic.currentLawyerModel!.loginInfo!.firstName ?? '';

    editProfileLogic.userProfileLastNameController.text =
        generalLogic.currentLawyerModel!.loginInfo!.lastName ?? '';

    editProfileLogic.userProfileUserNameController.text =
        generalLogic.currentLawyerModel!.loginInfo!.userName ?? '';

    editProfileLogic.userProfileDescriptionController.text =
        generalLogic.currentLawyerModel!.loginInfo!.description ?? '';

    editProfileLogic.userProfileAddressLine1Controller.text =
        generalLogic.currentLawyerModel!.loginInfo!.addressLine1 ?? '';

    editProfileLogic.userProfileAddressLine2Controller.text =
        generalLogic.currentLawyerModel!.loginInfo!.addressLine1 ?? '';

    editProfileLogic.userProfileZipCodeController.text =
        generalLogic.currentLawyerModel!.loginInfo!.zipCode ?? '';

    // editProfileLogic.uploadedProfileImage =
    //     generalLogic.currentLawyerModel!.loginInfo!.image;

    log("${generalLogic.currentLawyerModel!.loginInfo!.image} Log Image");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<EditProfileController>(
          builder: (editProfileController) {
        return ModalProgressHUD(
            progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
            inAsyncCall: generalController.formLoaderController,
            child: GestureDetector(
              onTap: () {
                final FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Scaffold(
                backgroundColor: AppColors.white,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(116),
                  child: Column(
                    children: [
                      AppBarWidget(
                        richTextSpan: TextSpan(
                          text: LanguageConstant.profile.tr,
                          style: AppTextStyles.appbarTextStyle2,
                          children: <TextSpan>[],
                        ),
                        leadingIcon: "assets/icons/Expand_left.png",
                        leadingOnTap: () {
                          if (indexPage > 0) {
                            setState(() {
                              indexPage--;
                            });
                          } else {
                            Get.back();
                            indexPage = 0;
                          }
                        },
                      ),
                      Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: AppColors.primaryColor),
                        child: TabBar(
                          tabAlignment: TabAlignment.start,
                          controller: tabController,
                          isScrollable: true,
                          labelColor: AppColors.white,
                          unselectedLabelColor: AppColors.secondaryColor,
                          dividerColor: AppColors.transparent,
                          padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 6.h),
                          indicatorPadding:
                              EdgeInsets.fromLTRB(0.w, 4.h, 0.w, 4.h),
                          labelPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                          labelStyle: AppTextStyles.buttonTextStyle2,
                          unselectedLabelStyle: AppTextStyles.buttonTextStyle7,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                              gradient: AppColors.gradientOne,
                              borderRadius: BorderRadius.circular(10)),
                          tabs: [
                            Tab(text: LanguageConstant.generalInfo.tr),
                            Tab(text: LanguageConstant.education.tr),
                            Tab(text: LanguageConstant.certificate.tr),
                            Tab(text: LanguageConstant.experience.tr),
                            Tab(text: LanguageConstant.podcast.tr),
                            Tab(text: LanguageConstant.services.tr),
                            Tab(text: LanguageConstant.events.tr),
                            Tab(text: LanguageConstant.blogs.tr),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                body: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.black, width: 1),
                      ),
                    ),
                    child: TabBarView(
                        controller: tabController,
                        children: <Widget>[
                          // Information
                          basicInformation(context, editProfileController,
                              generalController),

                          // Education
                          LawyerEducationWidget(),

                          // Certificate
                          LawyerCertificateWidget(),

                          // Experience
                          LawyerExperienceWidget(),

                          // experience(
                          //     context, editProfileController, generalController),
                          //  Center(
                          //   child: Padding(
                          //     padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                          //     child: Text(
                          //       LanguageConstant.noDataFound.tr,
                          //       style: AppTextStyles.bodyTextStyle2,
                          //     ),
                          //   ),
                          // ),
                          LawyerPodcastsWidget(),
                          LawyerServicesWidget(),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                              child: Text(
                                LanguageConstant.noDataFound.tr,
                                style: AppTextStyles.bodyTextStyle2,
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                              child: Text(
                                LanguageConstant.noDataFound.tr,
                                style: AppTextStyles.bodyTextStyle2,
                              ),
                            ),
                          ),
                        ])),
              ),
            ));
      });
    });
  }

  // Socail Links
  Widget social() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            style: AppTextStyles.hintTextStyle1,
            // controller: controller,
            decoration: InputDecoration(
              hintText: "Instagram link",
              hintStyle: AppTextStyles.hintTextStyle1,
              labelStyle: AppTextStyles.hintTextStyle1,
              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              isDense: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            style: AppTextStyles.hintTextStyle1,
            // controller: controller,
            decoration: InputDecoration(
              hintText: "Facebook link",
              hintStyle: AppTextStyles.hintTextStyle1,
              labelStyle: AppTextStyles.hintTextStyle1,
              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              isDense: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            style: AppTextStyles.hintTextStyle1,
            // controller: controller,
            decoration: InputDecoration(
              hintText: "Youtube link",
              hintStyle: AppTextStyles.hintTextStyle1,
              labelStyle: AppTextStyles.hintTextStyle1,
              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              isDense: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            style: AppTextStyles.hintTextStyle1,
            // controller: controller,
            decoration: InputDecoration(
              hintText: "Linkedin link",
              hintStyle: AppTextStyles.hintTextStyle1,
              labelStyle: AppTextStyles.hintTextStyle1,
              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              isDense: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ButtonWidgetOne(
            onTap: () {
              Get.toNamed(PageRoutes.homeScreen);
              setState(() {
                indexPage++;
              });
            },
            buttonText: "Continue",
            buttonTextStyle: AppTextStyles.bodyTextStyle8,
            borderRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget basicInformation(
      BuildContext context,
      EditProfileController editProfileController,
      GeneralController generalController) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Form(
          key: _userProfileUpdateFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: AppColors.gradientOne,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        imagePickerDialog(context);
                      },
                      child: editProfileLogic.profileImage == null
                          ? generalLogic.currentLawyerModel == null
                              ? Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  decoration: BoxDecoration(
                                      color: AppColors.tertiaryBgColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: AppColors.black)),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          "assets/icons/Upload_duotone_line.png"),
                                      const SizedBox(height: 4),
                                      Text(
                                        LanguageConstant.uploadImage.tr,
                                        style: AppTextStyles.bodyTextStyle1,
                                      )
                                    ],
                                  ),
                                )
                              : generalLogic.currentLawyerModel!.loginInfo!
                                          .image ==
                                      null
                                  ? Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 20, 20, 20),
                                      decoration: BoxDecoration(
                                          color: AppColors.tertiaryBgColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColors.black)),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                              "assets/icons/Upload_duotone_line.png"),
                                          const SizedBox(height: 4),
                                          Text(
                                            LanguageConstant.uploadImage.tr,
                                            style: AppTextStyles.bodyTextStyle1,
                                          )
                                        ],
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Image.network(
                                        scale: 4.h,
                                        '$mediaUrl${generalLogic.currentLawyerModel!.loginInfo!.image}',
                                        fit: BoxFit.cover,
                                        height: 110.h,
                                        width: 120.w,
                                      ))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.file(
                                scale: 3.h,
                                // '$mediaUrl${generalLogic.currentLawyerModel!.loginInfo!.image}',
                                editProfileController.profileImage!,
                                height: 110.h,
                                width: 120.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          generalController.storageBox.read('authToken') != null
                              ? "${generalController.currentLawyerModel!.loginInfo!.firstName} ${generalController.currentLawyerModel!.loginInfo!.lastName}"
                              : "",
                          style: AppTextStyles.bodyTextStyle5,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          generalController.storageBox.read('authToken') != null
                              ? "${generalController.currentLawyerModel!.email}"
                              : "",
                          style: AppTextStyles.bodyTextStyle6,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              TextFormFieldWidget(
                hintText: '* First Name',
                controller:
                    editProfileController.userProfileFirstNameController,
                // initialText: editUserProfileLogic
                //     .userProfileFirstNameController.text,
                onChanged: (String? value) {
                  editProfileController.userProfileFirstNameController.text ==
                      value;
                  editProfileController.update();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'First Name Field Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 14),
              TextFormFieldWidget(
                hintText: '* Last Name',
                controller: editProfileController.userProfileLastNameController,
                onChanged: (String? value) {
                  editProfileController.userProfileLastNameController.text ==
                      value;
                  editProfileController.update();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Last Name Field Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 14),
              TextFormFieldWidget(
                hintText: '* User Name',
                controller: editProfileController.userProfileUserNameController,
                onChanged: (String? value) {
                  editProfileController.userProfileUserNameController.text ==
                      value;
                  editProfileController.update();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'User Name Field Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 14),
              TextFormFieldWidget(
                hintText: '* Description',
                controller:
                    editProfileController.userProfileDescriptionController,
                // initialText: editProfileController
                //         .userProfileDescriptionController
                //         .text
                //         .isEmpty
                //     ? ''
                //     : editProfileController
                //         .userProfileDescriptionController.text,
                onChanged: (String? value) {
                  editProfileController.userProfileDescriptionController.text ==
                      value;
                  editProfileController.update();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Description Field Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 14),
              TextFormFieldWidget(
                hintText: '* Address Line 1',
                controller:
                    editProfileController.userProfileAddressLine1Controller,
                onChanged: (String? value) {
                  editProfileController
                          .userProfileAddressLine1Controller.text ==
                      value;
                  editProfileController.update();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Address Line 1 Field Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 14),
              TextFormFieldWidget(
                hintText: '* Address Line 2',
                controller:
                    editProfileController.userProfileAddressLine2Controller,
                onChanged: (String? value) {
                  editProfileController
                          .userProfileAddressLine2Controller.text ==
                      value;
                  editProfileController.update();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Address Line 2 Field Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 14),
              TextFormFieldWidget(
                hintText: '* Zip Code',
                controller: editProfileController.userProfileZipCodeController,
                onChanged: (String? value) {
                  editProfileController.userProfileZipCodeController.text ==
                      value;
                  editProfileController.update();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Zip Code Field Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWidgetOne(
                    onTap: () async {
                      ///---keyboard-close
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      if (_userProfileUpdateFormKey.currentState!.validate()) {
                        if (editProfileController.profileImage != null) {
                          log("${editProfileController.profileImage!.path} Inside If");
                          log(editProfileController
                              .userProfileFirstNameController.text);
                          log(editProfileController
                              .userProfileLastNameController.text);
                          log(editProfileController
                              .userProfileUserNameController.text);
                          log(editProfileController
                              .userProfileDescriptionController.text);
                          log(editProfileController
                              .userProfileZipCodeController.text);
                          log(editProfileController
                              .userProfileAddressLine1Controller.text);
                          log(editProfileController.profileImage!.path);
                          Get.find<GeneralController>()
                              .updateFormLoaderController(true);

                          editUserProfileImageRepo(
                            editProfileController
                                .userProfileFirstNameController.text,
                            editProfileController
                                .userProfileLastNameController.text,
                            editProfileController
                                .userProfileUserNameController.text,
                            editProfileController
                                .userProfileDescriptionController.text,
                            editProfileController
                                .userProfileAddressLine1Controller.text,
                            editProfileController
                                .userProfileAddressLine2Controller.text,
                            // 1,
                            // 1,
                            // 1,
                            editProfileController
                                .userProfileZipCodeController.text,
                            [1],
                            [1],
                            [1],
                            editProfileController.profileImage,
                            editProfileController.profileImage,
                          );
                        } else if (generalLogic
                                    .currentLawyerModel!.loginInfo!.image !=
                                null &&
                            editProfileController.profileImage == null) {
                          log(editProfileController
                              .userProfileFirstNameController.text);
                          log(editProfileController
                              .userProfileLastNameController.text);
                          log(editProfileController
                              .userProfileUserNameController.text);
                          log(editProfileController
                              .userProfileDescriptionController.text);
                          log(editProfileController
                              .userProfileZipCodeController.text);
                          log(editProfileController
                              .userProfileAddressLine1Controller.text);
                          // log(editProfileController.profileImage!.path);
                          Get.find<GeneralController>()
                              .updateFormLoaderController(true);
                          postMethod(
                              context,
                              editUserProfileURL,
                              {
                                "logged_in_as": "lawyer",
                                "first_name": editProfileController
                                    .userProfileFirstNameController.text,
                                "last_name": editProfileController
                                    .userProfileLastNameController.text,
                                "user_name": editProfileController
                                    .userProfileUserNameController.text,
                                "description": editProfileController
                                    .userProfileDescriptionController.text,
                                "address_line_1": editProfileController
                                    .userProfileAddressLine1Controller.text,
                                "address_line_2": editProfileController
                                    .userProfileAddressLine2Controller.text,
                                "city_id": 1,
                                "country_id": 1,
                                "state_id": 1,
                                "zip_code": editProfileController
                                    .userProfileZipCodeController.text,
                                "lawyer_categories": [1],
                                "languages": [1],
                                "tags": [1],
                              },
                              true,
                              editUserProfileDataRepo);
                        } else {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                  title: LanguageConstant.sorry.tr,
                                  titleColor: AppColors.customDialogErrorColor,
                                  descriptions: 'Inside Screen Popup',
                                  text: 'Ok',
                                  functionCall: () {
                                    Navigator.pop(context);
                                  },
                                  img: 'assets/icons/dialog_error.png',
                                );
                              });
                        }
                      }
                    },
                    buttonText: LanguageConstant.saveProfile.tr,
                    buttonTextStyle: AppTextStyles.buttonTextStyle1,
                    borderRadius: 10,
                  ),
                  SizedBox(width: 24.w),
                  ButtonWidgetOne(
                    onTap: () async {
                      ///---keyboard-close
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      setState(() {
                        tabController!.index = 1;
                      });
                    },
                    buttonText: LanguageConstant.continuE.tr,
                    buttonTextStyle: AppTextStyles.buttonTextStyle1,
                    borderRadius: 10,
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              ButtonWidgetOne(
                onTap: () {
                  getMethod(
                      context, deleteAccountURL, null, true, deleteAccountRepo);
                },
                buttonText: LanguageConstant.deleteAccount.tr,
                buttonTextStyle: AppTextStyles.buttonTextStyle1,
                borderRadius: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  void imagePickerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      Get.find<EditProfileController>().profileImagesList = [];
                    });
                    final XFile? image = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      imageQuality: 10,
                      maxWidth: 400,
                      maxHeight: 600,
                    );
                    if (image != null) {
                      Get.find<EditProfileController>()
                          .profileImagesList
                          .add(image);
                      setState(() {
                        Get.find<EditProfileController>().profileImage =
                            File(image.path);
                      });
                    }
                  },
                  child: Text(
                    'Camera',
                    style: AppTextStyles.buttonTextStyle8,
                  )),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      Get.find<EditProfileController>().profileImagesList = [];
                    });
                    final XFile? image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 10,
                      maxWidth: 400,
                      maxHeight: 600,
                    );
                    if (image != null) {
                      Get.find<EditProfileController>()
                          .profileImagesList
                          .add(image);
                      setState(() {
                        Get.find<EditProfileController>().profileImage =
                            File(image.path);
                      });
                    }
                  },
                  child: Text(
                    'Gallery',
                    style: AppTextStyles.buttonTextStyle8,
                  )),
            ],
          );
        });
  }
}

class LawyerCertificateWidget extends StatefulWidget {
  const LawyerCertificateWidget({super.key});

  @override
  State<LawyerCertificateWidget> createState() =>
      _LawyerCertificateWidgetState();
}

class _LawyerCertificateWidgetState extends State<LawyerCertificateWidget> {
  final GlobalKey<FormState> _userProfileUpdateFormKey = GlobalKey();

  bool isVisibleEducationForm = false;
  File? file;
  Future<void> filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });

      print(file!.path);
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    getMethod(context, getUserProfileCertificateURL, null, true,
        getLawyerCertificateRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<EditProfileController>(
          builder: (editProfileController) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Form(
              key: _userProfileUpdateFormKey,
              child: Column(
                children: [
                  isVisibleEducationForm == false
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LanguageConstant.addNewLawyerCertificate.tr,
                                style: AppTextStyles.subHeadingTextStyle2,
                              ),
                              SizedBox(
                                width: 70.w,
                                child: ButtonWidgetOne(
                                  onTap: () {
                                    setState(() {
                                      isVisibleEducationForm = true;
                                      if (editProfileController
                                          .certificateNameController
                                          .text
                                          .isNotEmpty) {
                                        editProfileController
                                            .certificateNameController
                                            .clear();
                                        editProfileController
                                            .certificateDescriptionController
                                            .clear();
                                      }
                                    });
                                  },
                                  buttonText: LanguageConstant.add.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle2,
                                  borderRadius: 8,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  isVisibleEducationForm == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormFieldWidget(
                              hintText: LanguageConstant.certificateName.tr,
                              controller: editProfileController
                                  .certificateNameController,
                              onChanged: (String? value) {
                                editProfileController
                                        .certificateNameController.text ==
                                    value;
                                editProfileController.update();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LanguageConstant
                                      .certificateNameFieldRequired.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                            TextField(
                              style: AppTextStyles.hintTextStyle1,
                              maxLines: 4,
                              controller: editProfileController
                                  .certificateDescriptionController,
                              onChanged: (String? value) {
                                editProfileController
                                        .certificateDescriptionController
                                        .text ==
                                    value;
                                editProfileController.update();
                              },
                              decoration: InputDecoration(
                                hintText: LanguageConstant.description.tr,
                                hintStyle: AppTextStyles.hintTextStyle1,
                                labelStyle: AppTextStyles.hintTextStyle1,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 12, 20, 12),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1,
                                      color: AppColors.customDialogErrorColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                filePick();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 24),
                                decoration: BoxDecoration(
                                    color: AppColors.tertiaryBgColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.black)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      LanguageConstant.uploadYourDocument.tr,
                                      style: AppTextStyles.buttonTextStyle8,
                                    ),
                                    SizedBox(width: 10.w),
                                    Image.asset("assets/icons/Upload.png")
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                              decoration: BoxDecoration(
                                color: AppColors.tertiaryBgColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 2, 0, 14),
                                    child: Text(
                                      LanguageConstant
                                          .professionalCertificate.tr,
                                      style: AppTextStyles.bodyTextStyle10,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/File_dock.png",
                                              height: 24.h,
                                            ),
                                            SizedBox(width: 10.w),
                                            file == null
                                                ? Text(
                                                    LanguageConstant
                                                        .certificateFileNameHere
                                                        .tr,
                                                    style: AppTextStyles
                                                        .hintTextStyle1,
                                                  )
                                                : Text(
                                                    file!.path
                                                        .toString()
                                                        .split("/")
                                                        .last
                                                        .toString(),
                                                    style: AppTextStyles
                                                        .hintTextStyle1,
                                                  ),
                                          ],
                                        ),
                                        SizedBox(width: 10.w),
                                        file == null
                                            ? const SizedBox()
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    file = null;
                                                  });
                                                },
                                                child: Image.asset(
                                                  "assets/icons/Subtract.png",
                                                  color: AppColors.primaryColor,
                                                  height: 20.h,
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(24, 6, 24, 16),
                                    child: Divider(
                                      height: 2,
                                      thickness: 2,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonWidgetOne(
                                  onTap: () {
                                    setState(() {
                                      isVisibleEducationForm = false;
                                    });
                                  },
                                  buttonText: LanguageConstant.back.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle1,
                                  borderRadius: 10,
                                ),
                                SizedBox(width: 10.w),
                                ButtonWidgetOne(
                                  onTap: () async {
                                    ///---keyboard-close
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    if (_userProfileUpdateFormKey.currentState!
                                        .validate()) {
                                      ///post-method
                                      addUserProfileCertificateDataRepo(
                                          editProfileController
                                              .certificateNameController.text,
                                          editProfileController
                                              .certificateDescriptionController
                                              .text,
                                          file,
                                          1);
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return CustomDialogBox(
                                              title: LanguageConstant.sorry.tr,
                                              titleColor: AppColors
                                                  .customDialogErrorColor,
                                              descriptions:
                                                  'Inside Screen Popup',
                                              text: 'Ok',
                                              functionCall: () {
                                                Navigator.pop(context);
                                              },
                                              img:
                                                  'assets/icons/dialog_error.png',
                                            );
                                          });
                                    }
                                  },
                                  buttonText: LanguageConstant.submit.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle1,
                                  borderRadius: 10,
                                ),
                              ],
                            ),
                          ],
                        )
                      : editProfileController
                              .lawyerProfileCertificateForPagination.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: editProfileController
                                  .lawyerProfileCertificateForPagination.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 14.h),
                                  padding:
                                      EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 4.h),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.black, width: 1.3),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            editProfileController
                                                .lawyerProfileCertificateForPagination[
                                                    index]
                                                .name!,
                                            style:
                                                AppTextStyles.bodyTextStyle11,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      Text(LanguageConstant.download.tr,
                                          style: AppTextStyles.bodyTextStyle11),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 40.w,
                                            height: 26.h,
                                            child: ButtonWidgetFive(
                                              onTap: () {
                                                setState(() {
                                                  isVisibleEducationForm = true;
                                                  editProfileController
                                                          .certificateNameController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileCertificateForPagination[
                                                              index]
                                                          .name!;
                                                  editProfileController
                                                          .certificateDescriptionController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileCertificateForPagination[
                                                              index]
                                                          .description!;
                                                });
                                              },
                                              buttonIcon: Icons.edit,
                                              buttonTextStyle: AppTextStyles
                                                  .buttonTextStyle2,
                                              borderRadius: 8,
                                              iconSize: 18,
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          SizedBox(
                                            width: 40.w,
                                            height: 26.h,
                                            child: ButtonWidgetFive(
                                              onTap: () {
                                                deleteMethod(
                                                    context,
                                                    "$addEditUserProfileCertificateURL/${editProfileController.lawyerProfileCertificateForPagination[index].id!}",
                                                    null,
                                                    true,
                                                    deleteUserProfileCertificateDataRepo);
                                              },
                                              buttonIcon: Icons.delete,
                                              buttonTextStyle: AppTextStyles
                                                  .buttonTextStyle2,
                                              borderRadius: 8,
                                              iconSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 80.h),
                                child: Text(
                                  LanguageConstant.noDataFound.tr,
                                  style: AppTextStyles.bodyTextStyle10,
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}

class LawyerExperienceWidget extends StatefulWidget {
  const LawyerExperienceWidget({super.key});

  @override
  State<LawyerExperienceWidget> createState() => _LawyerExperienceWidgetState();
}

class _LawyerExperienceWidgetState extends State<LawyerExperienceWidget> {
  final GlobalKey<FormState> _userProfileUpdateFormKey = GlobalKey();

  bool isVisibleEducationForm = false;
  File? file;
  Future<void> filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });

      print(file!.path);
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    getMethod(context, getUserProfileExperiencesURL, null, true,
        getLawyerExperienceRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<EditProfileController>(
          builder: (editProfileController) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Form(
              key: _userProfileUpdateFormKey,
              child: Column(
                children: [
                  isVisibleEducationForm == false
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LanguageConstant.addNewLawyerExperience.tr,
                                style: AppTextStyles.subHeadingTextStyle2,
                              ),
                              SizedBox(
                                width: 70.w,
                                child: ButtonWidgetOne(
                                  onTap: () {
                                    setState(() {
                                      isVisibleEducationForm = true;
                                      if (editProfileController
                                          .experienceCompanyNameController
                                          .text
                                          .isNotEmpty) {
                                        editProfileController
                                            .experienceCompanyNameController
                                            .clear();
                                        editProfileController
                                            .experienceDescriptionController
                                            .clear();
                                      }
                                    });
                                  },
                                  buttonText: LanguageConstant.add.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle2,
                                  borderRadius: 8,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  isVisibleEducationForm == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormFieldWidget(
                              hintText: LanguageConstant.companyName.tr,
                              controller: editProfileController
                                  .experienceCompanyNameController,
                              onChanged: (String? value) {
                                editProfileController
                                        .experienceCompanyNameController.text ==
                                    value;
                                editProfileController.update();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LanguageConstant
                                      .companyNameFieldRequired.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                            TextField(
                              style: AppTextStyles.hintTextStyle1,
                              maxLines: 4,
                              controller: editProfileController
                                  .experienceDescriptionController,
                              onChanged: (String? value) {
                                editProfileController
                                        .experienceDescriptionController.text ==
                                    value;
                                editProfileController.update();
                              },
                              decoration: InputDecoration(
                                hintText: LanguageConstant.description.tr,
                                hintStyle: AppTextStyles.hintTextStyle1,
                                labelStyle: AppTextStyles.hintTextStyle1,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 12, 20, 12),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1,
                                      color: AppColors.customDialogErrorColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  hintText: LanguageConstant.startDate.tr,
                                  controller: editProfileController
                                      .experienceStartDateController,
                                  onChanged: (String? value) {
                                    editProfileController
                                            .experienceStartDateController
                                            .text ==
                                        value;
                                    editProfileController.update();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LanguageConstant
                                          .startDateFieldRequired.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: TextFormFieldWidget(
                                  hintText: LanguageConstant.endDate.tr,
                                  controller: editProfileController
                                      .experienceEndDateController,
                                  onChanged: (String? value) {
                                    editProfileController
                                            .experienceEndDateController.text ==
                                        value;
                                    editProfileController.update();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LanguageConstant
                                          .endDateFieldRequired.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ]),
                            GestureDetector(
                              onTap: () {
                                filePick();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 24),
                                decoration: BoxDecoration(
                                    color: AppColors.tertiaryBgColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.black)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      LanguageConstant.uploadYourDocument.tr,
                                      style: AppTextStyles.buttonTextStyle8,
                                    ),
                                    const SizedBox(width: 10),
                                    Image.asset("assets/icons/Upload.png")
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                              decoration: BoxDecoration(
                                color: AppColors.tertiaryBgColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 2, 0, 14),
                                    child: Text(
                                      LanguageConstant
                                          .professionalCertificate.tr,
                                      style: AppTextStyles.bodyTextStyle10,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/File_dock.png",
                                              height: 24.h,
                                            ),
                                            SizedBox(width: 10.w),
                                            file == null
                                                ? Text(
                                                    LanguageConstant
                                                        .experienceFileNameHere
                                                        .tr,
                                                    style: AppTextStyles
                                                        .hintTextStyle1,
                                                  )
                                                : Text(
                                                    file!.path
                                                        .toString()
                                                        .split("/")
                                                        .last
                                                        .toString(),
                                                    style: AppTextStyles
                                                        .hintTextStyle1,
                                                  ),
                                          ],
                                        ),
                                        SizedBox(width: 10.w),
                                        file == null
                                            ? const SizedBox()
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    file = null;
                                                  });
                                                },
                                                child: Image.asset(
                                                  "assets/icons/Subtract.png",
                                                  color: AppColors.primaryColor,
                                                  height: 20.h,
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(24, 6, 24, 16),
                                    child: Divider(
                                      height: 2,
                                      thickness: 2,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonWidgetOne(
                                  onTap: () {
                                    setState(() {
                                      isVisibleEducationForm = false;
                                    });
                                  },
                                  buttonText: LanguageConstant.back.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle1,
                                  borderRadius: 10,
                                ),
                                SizedBox(width: 10.w),
                                ButtonWidgetOne(
                                  onTap: () async {
                                    ///---keyboard-close
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    if (_userProfileUpdateFormKey.currentState!
                                        .validate()) {
                                      ///post-method
                                      addUserProfileExperienceDataRepo(
                                          editProfileController
                                              .experienceCompanyNameController
                                              .text,
                                          editProfileController
                                              .experienceDescriptionController
                                              .text,
                                          editProfileController
                                              .experienceStartDateController
                                              .text,
                                          editProfileController
                                              .experienceEndDateController.text,
                                          file,
                                          1);
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return CustomDialogBox(
                                              title: LanguageConstant.sorry.tr,
                                              titleColor: AppColors
                                                  .customDialogErrorColor,
                                              descriptions:
                                                  'Inside Screen Popup',
                                              text: 'Ok',
                                              functionCall: () {
                                                Navigator.pop(context);
                                              },
                                              img:
                                                  'assets/icons/dialog_error.png',
                                            );
                                          });
                                    }
                                  },
                                  buttonText: LanguageConstant.submit.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle1,
                                  borderRadius: 10,
                                ),
                              ],
                            ),
                          ],
                        )
                      : editProfileController
                              .lawyerProfileExperienceForPagination.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: editProfileController
                                  .lawyerProfileExperienceForPagination.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 14.h),
                                  padding:
                                      EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 4.h),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.black, width: 1.3),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            editProfileController
                                                .lawyerProfileExperienceForPagination[
                                                    index]
                                                .company!,
                                            style:
                                                AppTextStyles.bodyTextStyle11,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      Text(LanguageConstant.download.tr,
                                          style: AppTextStyles.bodyTextStyle11),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 40.w,
                                            height: 26.h,
                                            child: ButtonWidgetFive(
                                              onTap: () {
                                                setState(() {
                                                  isVisibleEducationForm = true;
                                                  editProfileController
                                                          .experienceCompanyNameController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileExperienceForPagination[
                                                              index]
                                                          .company!;
                                                  editProfileController
                                                          .experienceDescriptionController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileExperienceForPagination[
                                                              index]
                                                          .description!;
                                                  editProfileController
                                                          .experienceStartDateController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileExperienceForPagination[
                                                              index]
                                                          .from!;
                                                  editProfileController
                                                          .experienceEndDateController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileExperienceForPagination[
                                                              index]
                                                          .to!;
                                                });
                                              },
                                              buttonIcon: Icons.edit,
                                              buttonTextStyle: AppTextStyles
                                                  .buttonTextStyle2,
                                              borderRadius: 8,
                                              iconSize: 18,
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          SizedBox(
                                            width: 40.w,
                                            height: 26.h,
                                            child: ButtonWidgetFive(
                                              onTap: () {
                                                deleteMethod(
                                                    context,
                                                    "$addEditUserProfileExperienceURL/${editProfileController.lawyerProfileExperienceForPagination[index].id!}",
                                                    null,
                                                    true,
                                                    deleteUserProfileExperienceDataRepo);
                                              },
                                              buttonIcon: Icons.delete,
                                              buttonTextStyle: AppTextStyles
                                                  .buttonTextStyle2,
                                              borderRadius: 8,
                                              iconSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 80.h),
                                child: Text(
                                  LanguageConstant.noDataFound.tr,
                                  style: AppTextStyles.bodyTextStyle10,
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}

class LawyerEducationWidget extends StatefulWidget {
  const LawyerEducationWidget({super.key});

  @override
  State<LawyerEducationWidget> createState() => _LawyerEducationWidgetState();
}

class _LawyerEducationWidgetState extends State<LawyerEducationWidget> {
  final GlobalKey<FormState> _userProfileUpdateFormKey = GlobalKey();

  bool isVisibleEducationForm = false;
  File? file;
  Future<void> filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });

      print(file!.path);
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    getMethod(context, getUserProfileEducationsURL, null, true,
        getLawyerEducationRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<EditProfileController>(
          builder: (editProfileController) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Form(
              key: _userProfileUpdateFormKey,
              child: Column(
                children: [
                  isVisibleEducationForm == false
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LanguageConstant.addNewLawyerEducation.tr,
                                style: AppTextStyles.subHeadingTextStyle2,
                              ),
                              SizedBox(
                                width: 70.w,
                                child: ButtonWidgetOne(
                                  onTap: () {
                                    setState(() {
                                      isVisibleEducationForm = true;
                                      if (editProfileController
                                          .educationInstituteNameController
                                          .text
                                          .isNotEmpty) {
                                        editProfileController
                                            .educationInstituteNameController
                                            .clear();
                                        editProfileController
                                            .educationDescriptionController
                                            .clear();
                                        editProfileController
                                            .educationStartDateController
                                            .clear();
                                        editProfileController
                                            .educationEndDateController
                                            .clear();
                                        editProfileController
                                            .educationDegreeController
                                            .clear();
                                        editProfileController
                                            .educationSubjectController
                                            .clear();
                                      }
                                    });
                                  },
                                  buttonText: LanguageConstant.add.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle2,
                                  borderRadius: 8,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  isVisibleEducationForm == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormFieldWidget(
                              hintText: LanguageConstant.instituteName.tr,
                              controller: editProfileController
                                  .educationInstituteNameController,
                              onChanged: (String? value) {
                                editProfileController
                                        .educationInstituteNameController
                                        .text ==
                                    value;
                                editProfileController.update();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LanguageConstant
                                      .instituteNameFieldRequired.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                            TextField(
                              style: AppTextStyles.hintTextStyle1,
                              maxLines: 4,
                              controller: editProfileController
                                  .educationDescriptionController,
                              onChanged: (String? value) {
                                editProfileController
                                        .educationDescriptionController.text ==
                                    value;
                                editProfileController.update();
                              },
                              decoration: InputDecoration(
                                hintText: LanguageConstant.description.tr,
                                hintStyle: AppTextStyles.hintTextStyle1,
                                labelStyle: AppTextStyles.hintTextStyle1,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 12, 20, 12),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1,
                                      color: AppColors.customDialogErrorColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  hintText: LanguageConstant.degree.tr,
                                  controller: editProfileController
                                      .educationDegreeController,
                                  onChanged: (String? value) {
                                    editProfileController
                                            .educationDegreeController.text ==
                                        value;
                                    editProfileController.update();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LanguageConstant
                                          .degreeFieldRequired.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: TextFormFieldWidget(
                                  hintText: LanguageConstant.subject.tr,
                                  controller: editProfileController
                                      .educationSubjectController,
                                  onChanged: (String? value) {
                                    editProfileController
                                            .educationSubjectController.text ==
                                        value;
                                    editProfileController.update();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LanguageConstant
                                          .subjectFieldRequired.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ]),
                            SizedBox(height: 20.h),
                            Row(children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  hintText: LanguageConstant.startDate.tr,
                                  controller: editProfileController
                                      .educationStartDateController,
                                  onChanged: (String? value) {
                                    editProfileController
                                            .educationStartDateController
                                            .text ==
                                        value;
                                    editProfileController.update();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LanguageConstant
                                          .startDateFieldRequired.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: TextFormFieldWidget(
                                  hintText: LanguageConstant.endDate.tr,
                                  controller: editProfileController
                                      .educationEndDateController,
                                  onChanged: (String? value) {
                                    editProfileController
                                            .educationEndDateController.text ==
                                        value;
                                    editProfileController.update();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LanguageConstant
                                          .endDateFieldRequired.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ]),
                            GestureDetector(
                              onTap: () {
                                filePick();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 24),
                                decoration: BoxDecoration(
                                    color: AppColors.tertiaryBgColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.black)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      LanguageConstant.uploadYourDocument.tr,
                                      style: AppTextStyles.buttonTextStyle8,
                                    ),
                                    const SizedBox(width: 10),
                                    Image.asset("assets/icons/Upload.png")
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                              decoration: BoxDecoration(
                                color: AppColors.tertiaryBgColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 2, 0, 14),
                                    child: Text(
                                      LanguageConstant
                                          .professionalCertificate.tr,
                                      style: AppTextStyles.bodyTextStyle10,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/File_dock.png",
                                              height: 24.h,
                                              color: AppColors.black,
                                            ),
                                            SizedBox(width: 10.w),
                                            file == null
                                                ? Text(
                                                    LanguageConstant
                                                        .educationFileNameHere
                                                        .tr,
                                                    style: AppTextStyles
                                                        .hintTextStyle1,
                                                  )
                                                : Text(
                                                    file!.path
                                                        .toString()
                                                        .split("/")
                                                        .last
                                                        .toString(),
                                                    style: AppTextStyles
                                                        .hintTextStyle1,
                                                  ),
                                          ],
                                        ),
                                        SizedBox(width: 10.w),
                                        file == null
                                            ? const SizedBox()
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    file = null;
                                                  });
                                                },
                                                child: Image.asset(
                                                  "assets/icons/Subtract.png",
                                                  color: AppColors.primaryColor,
                                                  height: 20.h,
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(24, 6, 24, 16),
                                    child: Divider(
                                      height: 2,
                                      thickness: 2,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonWidgetOne(
                                  onTap: () {
                                    setState(() {
                                      isVisibleEducationForm = false;
                                    });
                                  },
                                  buttonText: LanguageConstant.back.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle1,
                                  borderRadius: 10,
                                ),
                                SizedBox(width: 10.w),
                                ButtonWidgetOne(
                                  onTap: () async {
                                    ///---keyboard-close
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    if (_userProfileUpdateFormKey.currentState!
                                        .validate()) {
                                      ///post-method
                                      addUserProfileEducationDataRepo(
                                          editProfileController
                                              .educationInstituteNameController
                                              .text,
                                          editProfileController
                                              .educationDescriptionController
                                              .text,
                                          editProfileController
                                              .educationStartDateController
                                              .text,
                                          editProfileController
                                              .educationEndDateController.text,
                                          editProfileController
                                              .educationDegreeController.text,
                                          editProfileController
                                              .educationSubjectController.text,
                                          file,
                                          1);
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return CustomDialogBox(
                                              title: LanguageConstant.sorry.tr,
                                              titleColor: AppColors
                                                  .customDialogErrorColor,
                                              descriptions:
                                                  'Inside Screen Popup',
                                              text: 'Ok',
                                              functionCall: () {
                                                Navigator.pop(context);
                                              },
                                              img:
                                                  'assets/icons/dialog_error.png',
                                            );
                                          });
                                    }
                                  },
                                  buttonText: LanguageConstant.submit.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle1,
                                  borderRadius: 10,
                                ),
                              ],
                            ),
                          ],
                        )
                      : editProfileController
                              .lawyerProfileEducationForPagination.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: editProfileController
                                  .lawyerProfileEducationForPagination.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 14.h),
                                  padding:
                                      EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 4.h),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.black, width: 1.3),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            editProfileController
                                                .lawyerProfileEducationForPagination[
                                                    index]
                                                .institute!,
                                            style:
                                                AppTextStyles.bodyTextStyle11,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      Text(LanguageConstant.download.tr,
                                          style: AppTextStyles.bodyTextStyle11),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 40.w,
                                            height: 26.h,
                                            child: ButtonWidgetFive(
                                              onTap: () {
                                                setState(() {
                                                  isVisibleEducationForm = true;
                                                  editProfileController
                                                          .educationInstituteNameController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileEducationForPagination[
                                                              index]
                                                          .institute!;
                                                  editProfileController
                                                          .educationDescriptionController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileEducationForPagination[
                                                              index]
                                                          .description!;
                                                  editProfileController
                                                          .educationStartDateController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileEducationForPagination[
                                                              index]
                                                          .from!;
                                                  editProfileController
                                                          .educationEndDateController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileEducationForPagination[
                                                              index]
                                                          .to!;
                                                  editProfileController
                                                          .educationDegreeController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileEducationForPagination[
                                                              index]
                                                          .degree!;
                                                  editProfileController
                                                          .educationSubjectController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileEducationForPagination[
                                                              index]
                                                          .subject!;
                                                });
                                              },
                                              buttonIcon: Icons.edit,
                                              buttonTextStyle: AppTextStyles
                                                  .buttonTextStyle2,
                                              borderRadius: 8,
                                              iconSize: 18,
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          SizedBox(
                                            width: 40.w,
                                            height: 26.h,
                                            child: ButtonWidgetFive(
                                              onTap: () {
                                                deleteMethod(
                                                    context,
                                                    "$addEditUserProfileEducationURL/${editProfileController.lawyerProfileEducationForPagination[index].id!}",
                                                    null,
                                                    true,
                                                    deleteUserProfileEducationDataRepo);
                                              },
                                              buttonIcon: Icons.delete,
                                              buttonTextStyle: AppTextStyles
                                                  .buttonTextStyle2,
                                              borderRadius: 8,
                                              iconSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 80.h),
                                child: Text(
                                  LanguageConstant.noDataFound.tr,
                                  style: AppTextStyles.bodyTextStyle10,
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}

class LawyerPodcastsWidget extends StatefulWidget {
  const LawyerPodcastsWidget({super.key});

  @override
  State<LawyerPodcastsWidget> createState() => _LawyerPodcastsWidgetState();
}

class _LawyerPodcastsWidgetState extends State<LawyerPodcastsWidget> {
  final GlobalKey<FormState> _userProfileUpdateFormKey = GlobalKey();

  bool isVisiblePodcastForm = false;
  File? file;
  File? audioFile;
  File? videoFile;
  dynamic selectedFileType;
  dynamic selectedLinkType;

  Future<void> filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });

      print(file!.path);
    } else {
      // User canceled the picker
    }
  }

  Future<void> audioFilePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        audioFile = File(result.files.single.path!);
      });

      print(audioFile!.path);
    } else {
      // User canceled the picker
    }
  }

  Future<void> videoFilePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        videoFile = File(result.files.single.path!);
      });

      print(videoFile!.path);
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    getMethod(
        context, getUserProfilePodcastsURL, null, true, getLawyerPodcastsRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<EditProfileController>(
          builder: (editProfileController) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Form(
              key: _userProfileUpdateFormKey,
              child: Column(
                children: [
                  isVisiblePodcastForm == false
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LanguageConstant.addNewLawyerPodcast.tr,
                                style: AppTextStyles.subHeadingTextStyle2,
                              ),
                              SizedBox(
                                width: 70.w,
                                child: ButtonWidgetOne(
                                  onTap: () {
                                    setState(() {
                                      isVisiblePodcastForm = true;
                                      if (editProfileController
                                          .experienceCompanyNameController
                                          .text
                                          .isNotEmpty) {
                                        editProfileController
                                            .experienceCompanyNameController
                                            .clear();
                                        editProfileController
                                            .experienceDescriptionController
                                            .clear();
                                      }
                                    });
                                  },
                                  buttonText: LanguageConstant.add.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle2,
                                  borderRadius: 8,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  isVisiblePodcastForm == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormFieldWidget(
                              hintText: LanguageConstant.name.tr,
                              controller:
                                  editProfileController.podcastNameController,
                              onChanged: (String? value) {
                                editProfileController
                                        .podcastNameController.text ==
                                    value;
                                editProfileController.update();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LanguageConstant.nameFieldRequired.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                            TextField(
                              style: AppTextStyles.hintTextStyle1,
                              maxLines: 4,
                              controller: editProfileController
                                  .podcastDescriptionController,
                              onChanged: (String? value) {
                                editProfileController
                                        .podcastDescriptionController.text ==
                                    value;
                                editProfileController.update();
                              },
                              decoration: InputDecoration(
                                hintText: LanguageConstant.description.tr,
                                hintStyle: AppTextStyles.hintTextStyle1,
                                labelStyle: AppTextStyles.hintTextStyle1,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 12, 20, 12),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1,
                                      color: AppColors.customDialogErrorColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(children: [
                              Expanded(
                                child: DropdownButtonFormField(
                                  borderRadius: BorderRadius.circular(10),
                                  hint: Text(
                                    LanguageConstant.selectFileType.tr,
                                    style: AppTextStyles.hintTextStyle1,
                                  ),
                                  items: <String>[
                                    LanguageConstant.audio.tr,
                                    LanguageConstant.video.tr,
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: DropdownMenuItem(
                                        child: Row(
                                          children: [
                                            Text(value,
                                                style: AppTextStyles
                                                    .bodyTextStyle11),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedFileType = newValue;

                                      print(
                                          "File TYPE SELECTED $selectedFileType");
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(16, 6, 16, 6),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: AppColors.black,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: AppColors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.black,
                                  ),
                                  iconEnabledColor: Colors.white, //Icon color
                                  style: AppTextStyles.subHeadingTextStyle1,
                                  dropdownColor: AppColors
                                      .white, //dropdown background color
                                  isExpanded:
                                      true, //make true to make width 100%
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: DropdownButtonFormField(
                                  borderRadius: BorderRadius.circular(10),
                                  hint: Text(
                                    LanguageConstant.selectLinkType.tr,
                                    style: AppTextStyles.hintTextStyle1,
                                  ),
                                  items: <String>[
                                    LanguageConstant.internal.tr,
                                    LanguageConstant.external.tr,
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: DropdownMenuItem(
                                        child: Row(
                                          children: [
                                            Text(value,
                                                style: AppTextStyles
                                                    .bodyTextStyle11),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedLinkType = newValue;

                                      print(
                                          "LINK TYPE SELECTED $selectedLinkType");
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(16, 6, 16, 6),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: AppColors.black,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: AppColors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.black,
                                  ),
                                  iconEnabledColor: Colors.white, //Icon color
                                  style: AppTextStyles.subHeadingTextStyle1,
                                  dropdownColor: AppColors
                                      .white, //dropdown background color
                                  isExpanded:
                                      true, //make true to make width 100%
                                ),
                              ),
                            ]),
                            selectedLinkType == "external"
                                ? Padding(
                                    padding: EdgeInsets.only(top: 20.h),
                                    child: TextFormFieldWidget(
                                      hintText: LanguageConstant.fileURL.tr,
                                      controller: editProfileController
                                          .podcastFileURLController,
                                      onChanged: (String? value) {
                                        editProfileController
                                                .podcastFileURLController
                                                .text ==
                                            value;
                                        editProfileController.update();
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return LanguageConstant
                                              .fileURLFieldRequired.tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  )
                                : selectedLinkType == "internal" &&
                                        selectedFileType != null
                                    ? GestureDetector(
                                        onTap: () {
                                          selectedFileType == "audio"
                                              ? audioFilePick()
                                              : videoFilePick();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 12, 0, 12),
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 0),
                                          decoration: BoxDecoration(
                                              color: AppColors.tertiaryBgColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: AppColors.black)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                selectedFileType == "audio"
                                                    ? LanguageConstant
                                                        .uploadYourAudioFile.tr
                                                    : LanguageConstant
                                                        .uploadYourVideoFile.tr,
                                                style: AppTextStyles
                                                    .buttonTextStyle7,
                                              ),
                                              const SizedBox(width: 10),
                                              Image.asset(
                                                  "assets/icons/Upload.png")
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                            GestureDetector(
                              onTap: () {
                                filePick();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 24),
                                decoration: BoxDecoration(
                                    color: AppColors.tertiaryBgColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.black)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      LanguageConstant.uploadYourDocument.tr,
                                      style: AppTextStyles.buttonTextStyle8,
                                    ),
                                    const SizedBox(width: 10),
                                    Image.asset("assets/icons/Upload.png")
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                              decoration: BoxDecoration(
                                color: AppColors.tertiaryBgColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 2, 0, 14),
                                    child: Text(
                                      LanguageConstant.image.tr,
                                      style: AppTextStyles.bodyTextStyle10,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/File_dock.png",
                                              height: 24.h,
                                              color: AppColors.black,
                                            ),
                                            SizedBox(width: 10.w),
                                            file == null
                                                ? Text(
                                                    LanguageConstant
                                                        .podcastFileNameHere.tr,
                                                    style: AppTextStyles
                                                        .hintTextStyle1,
                                                  )
                                                : Text(
                                                    file!.path
                                                        .toString()
                                                        .split("/")
                                                        .last
                                                        .toString(),
                                                    style: AppTextStyles
                                                        .hintTextStyle1,
                                                  ),
                                          ],
                                        ),
                                        SizedBox(width: 10.w),
                                        file == null
                                            ? const SizedBox()
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    file = null;
                                                  });
                                                },
                                                child: Image.asset(
                                                  "assets/icons/Subtract.png",
                                                  color: AppColors.primaryColor,
                                                  height: 20.h,
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(24, 6, 24, 16),
                                    child: Divider(
                                      height: 2,
                                      thickness: 2,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonWidgetOne(
                                  onTap: () {
                                    setState(() {
                                      isVisiblePodcastForm = false;
                                    });
                                  },
                                  buttonText: LanguageConstant.back.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle1,
                                  borderRadius: 10,
                                ),
                                SizedBox(width: 10.w),
                                ButtonWidgetOne(
                                  onTap: () async {
                                    ///---keyboard-close
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    if (_userProfileUpdateFormKey.currentState!
                                        .validate()) {
                                      ///post-method
                                      addUserProfilePodcastDataRepo(
                                          editProfileController
                                              .podcastNameController.text,
                                          editProfileController
                                              .podcastDescriptionController
                                              .text,
                                          selectedFileType,
                                          selectedLinkType,
                                          "1",
                                          editProfileController
                                              .podcastFileURLController.text,
                                          file,
                                          audioFile,
                                          videoFile,
                                          1);
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return CustomDialogBox(
                                              title: LanguageConstant.sorry.tr,
                                              titleColor: AppColors
                                                  .customDialogErrorColor,
                                              descriptions:
                                                  'Inside Screen Popup',
                                              text: 'Ok',
                                              functionCall: () {
                                                Navigator.pop(context);
                                              },
                                              img:
                                                  'assets/icons/dialog_error.png',
                                            );
                                          });
                                    }
                                  },
                                  buttonText: LanguageConstant.submit.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle1,
                                  borderRadius: 10,
                                ),
                              ],
                            ),
                          ],
                        )
                      : editProfileController
                              .lawyerProfilePodcastForPagination.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: editProfileController
                                  .lawyerProfilePodcastForPagination.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 14.h),
                                  padding:
                                      EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 4.h),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.black, width: 1.3),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                            editProfileController
                                                .lawyerProfilePodcastForPagination[
                                                    index]
                                                .name!,
                                            style:
                                                AppTextStyles.bodyTextStyle11),
                                      ),
                                      SizedBox(width: 16.w),
                                      Text(LanguageConstant.download.tr,
                                          style: AppTextStyles.bodyTextStyle11),
                                      SizedBox(width: 16.w),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 40.w,
                                            height: 26.h,
                                            child: ButtonWidgetFive(
                                              onTap: () {
                                                setState(() {
                                                  isVisiblePodcastForm = true;
                                                  editProfileController
                                                          .podcastNameController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfilePodcastForPagination[
                                                              index]
                                                          .name!;
                                                  editProfileController
                                                          .podcastDescriptionController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfilePodcastForPagination[
                                                              index]
                                                          .description!;
                                                  selectedFileType =
                                                      editProfileController
                                                          .lawyerProfilePodcastForPagination[
                                                              index]
                                                          .fileType!;
                                                  selectedLinkType =
                                                      editProfileController
                                                          .lawyerProfilePodcastForPagination[
                                                              index]
                                                          .linkType!;
                                                  editProfileController
                                                          .podcastFileURLController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfilePodcastForPagination[
                                                              index]
                                                          .fileUrl!;
                                                });
                                              },
                                              buttonIcon: Icons.edit,
                                              buttonTextStyle: AppTextStyles
                                                  .buttonTextStyle2,
                                              borderRadius: 8,
                                              iconSize: 18,
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          SizedBox(
                                            width: 40.w,
                                            height: 26.h,
                                            child: ButtonWidgetFive(
                                              onTap: () {
                                                deleteMethod(
                                                    context,
                                                    "$addEditUserProfilePodcastURL/${editProfileController.lawyerProfilePodcastForPagination[index].id!}",
                                                    null,
                                                    true,
                                                    deleteUserProfilePodcastDataRepo);
                                              },
                                              buttonIcon: Icons.delete,
                                              buttonTextStyle: AppTextStyles
                                                  .buttonTextStyle2,
                                              borderRadius: 8,
                                              iconSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 80.h),
                                child: Text(
                                  LanguageConstant.noDataFound.tr,
                                  style: AppTextStyles.bodyTextStyle10,
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}

class LawyerServicesWidget extends StatefulWidget {
  const LawyerServicesWidget({super.key});

  @override
  State<LawyerServicesWidget> createState() => _LawyerServicesWidgetState();
}

class _LawyerServicesWidgetState extends State<LawyerServicesWidget> {
  final GlobalKey<FormState> _userProfileUpdateFormKey = GlobalKey();

  bool isVisibleServiceForm = false;
  File? file;
  dynamic selectedServiceCategoryName;
  dynamic selectedServiceCategoryId;

  Future<void> filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });

      print(file!.path);
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    getMethod(
        context, getUserProfileServicesURL, null, true, getLawyerServicesRepo);
    getMethod(context, getLawyerServiceCategoriesURL, null, true,
        getLawyerServiceCategoriesRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<EditProfileController>(
          builder: (editProfileController) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Form(
              key: _userProfileUpdateFormKey,
              child: Column(
                children: [
                  isVisibleServiceForm == false
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LanguageConstant.addNewLawyerServices.tr,
                                style: AppTextStyles.subHeadingTextStyle2,
                              ),
                              SizedBox(
                                width: 70.w,
                                child: ButtonWidgetOne(
                                  onTap: () {
                                    setState(() {
                                      isVisibleServiceForm = true;
                                      // if (editProfileController
                                      //     .serviceCompanyNameController
                                      //     .text
                                      //     .isNotEmpty) {
                                      //   editProfileController
                                      //       .serviceCompanyNameController
                                      //       .clear();
                                      //   editProfileController
                                      //       .serviceDescriptionController
                                      //       .clear();
                                      // }
                                    });
                                  },
                                  buttonText: LanguageConstant.add.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle2,
                                  borderRadius: 8,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  isVisibleServiceForm == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormFieldWidget(
                              hintText: LanguageConstant.name.tr,
                              controller:
                                  editProfileController.serviceNameController,
                              onChanged: (String? value) {
                                editProfileController
                                        .serviceNameController.text ==
                                    value;
                                editProfileController.update();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LanguageConstant.nameFieldRequired.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                            TextField(
                              style: AppTextStyles.hintTextStyle1,
                              maxLines: 4,
                              controller: editProfileController
                                  .serviceDescriptionController,
                              onChanged: (String? value) {
                                editProfileController
                                        .serviceDescriptionController.text ==
                                    value;
                                editProfileController.update();
                              },
                              decoration: InputDecoration(
                                hintText: LanguageConstant.description.tr,
                                hintStyle: AppTextStyles.hintTextStyle1,
                                labelStyle: AppTextStyles.hintTextStyle1,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 12, 20, 12),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1,
                                      color: AppColors.customDialogErrorColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            DropdownButtonFormField(
                              borderRadius: BorderRadius.circular(10),
                              hint: Text(
                                LanguageConstant.serviceCategories.tr,
                                style: AppTextStyles.hintTextStyle1,
                              ),
                              initialValue: selectedServiceCategoryId,
                              items: editProfileController
                                  .getLawyerServiceCategoriesModel.data
                                  ?.map((serviceCategoriesName) {
                                return DropdownMenuItem(
                                  value: serviceCategoriesName.id,
                                  child: DropdownMenuItem(
                                    child: Row(
                                      children: [
                                        Text(serviceCategoriesName.name!,
                                            style:
                                                AppTextStyles.bodyTextStyle11),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedServiceCategoryId = newValue;

                                  print(
                                      "Service Category ID $selectedServiceCategoryId");
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(16, 6, 16, 6),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: AppColors.black,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: AppColors.black,
                                    width: 1,
                                  ),
                                ),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.black,
                              ),
                              iconEnabledColor: Colors.white, //Icon color
                              style: AppTextStyles.subHeadingTextStyle1,
                              dropdownColor:
                                  AppColors.white, //dropdown background color
                              isExpanded: true, //make true to make width 100%
                            ),
                            SizedBox(height: 20.h),
                            TextFormFieldWidget(
                              hintText: LanguageConstant.price.tr,
                              controller:
                                  editProfileController.servicePriceController,
                              onChanged: (String? value) {
                                editProfileController
                                        .servicePriceController.text ==
                                    value;
                                editProfileController.update();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LanguageConstant
                                      .priceFieldIsRequired.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                filePick();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 24),
                                decoration: BoxDecoration(
                                    color: AppColors.tertiaryBgColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.black)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      LanguageConstant.uploadYourFile.tr,
                                      style: AppTextStyles.buttonTextStyle8,
                                    ),
                                    SizedBox(width: 10.w),
                                    Image.asset("assets/icons/Upload.png")
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                              decoration: BoxDecoration(
                                color: AppColors.tertiaryBgColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 2, 0, 14),
                                    child: Text(
                                      LanguageConstant.image.tr,
                                      style: AppTextStyles.bodyTextStyle10,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/File_dock.png",
                                              height: 24.h,
                                              color: AppColors.black,
                                            ),
                                            SizedBox(width: 10.w),
                                            file == null
                                                ? Text(
                                                    LanguageConstant
                                                        .serviceFileNameHere.tr,
                                                    style: AppTextStyles
                                                        .hintTextStyle1,
                                                  )
                                                : Text(
                                                    file!.path
                                                        .toString()
                                                        .split("/")
                                                        .last
                                                        .toString(),
                                                    style: AppTextStyles
                                                        .hintTextStyle1,
                                                  ),
                                          ],
                                        ),
                                        SizedBox(width: 10.w),
                                        file == null
                                            ? const SizedBox()
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    file = null;
                                                  });
                                                },
                                                child: Image.asset(
                                                  "assets/icons/Subtract.png",
                                                  color: AppColors.primaryColor,
                                                  height: 20.h,
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(24, 6, 24, 16),
                                    child: Divider(
                                      height: 2,
                                      thickness: 2,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonWidgetOne(
                                  onTap: () {
                                    setState(() {
                                      isVisibleServiceForm = false;
                                    });
                                  },
                                  buttonText: LanguageConstant.back.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle1,
                                  borderRadius: 10,
                                ),
                                SizedBox(width: 10.w),
                                ButtonWidgetOne(
                                  onTap: () async {
                                    ///---keyboard-close
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    if (_userProfileUpdateFormKey.currentState!
                                        .validate()) {
                                      ///post-method
                                      addUserProfileServiceDataRepo(
                                          editProfileController
                                              .serviceNameController.text,
                                          editProfileController
                                              .serviceDescriptionController
                                              .text,
                                          selectedServiceCategoryId.toString(),
                                          "1",
                                          file,
                                          editProfileController
                                              .servicePriceController.text,
                                          1);
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return CustomDialogBox(
                                              title: LanguageConstant.sorry.tr,
                                              titleColor: AppColors
                                                  .customDialogErrorColor,
                                              descriptions:
                                                  'Inside Screen Popup',
                                              text: 'Ok',
                                              functionCall: () {
                                                Navigator.pop(context);
                                              },
                                              img:
                                                  'assets/icons/dialog_error.png',
                                            );
                                          });
                                    }
                                  },
                                  buttonText: LanguageConstant.submit.tr,
                                  buttonTextStyle:
                                      AppTextStyles.buttonTextStyle1,
                                  borderRadius: 10,
                                ),
                              ],
                            ),
                          ],
                        )
                      : editProfileController
                              .lawyerProfileServiceForPagination.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: editProfileController
                                  .lawyerProfileServiceForPagination.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 14.h),
                                  padding:
                                      EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 4.h),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.black, width: 1.3),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            editProfileController
                                                .lawyerProfileServiceForPagination[
                                                    index]
                                                .name!,
                                            style:
                                                AppTextStyles.bodyTextStyle11,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      SizedBox(width: 16.w),
                                      Text(LanguageConstant.download.tr,
                                          style: AppTextStyles.bodyTextStyle11),
                                      SizedBox(width: 16.w),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 40.w,
                                            height: 26.h,
                                            child: ButtonWidgetFive(
                                              onTap: () {
                                                setState(() {
                                                  isVisibleServiceForm = true;
                                                  editProfileController
                                                          .serviceNameController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileServiceForPagination[
                                                              index]
                                                          .name!;
                                                  editProfileController
                                                          .serviceDescriptionController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileServiceForPagination[
                                                              index]
                                                          .description!;
                                                  selectedServiceCategoryId =
                                                      editProfileController
                                                          .lawyerProfileServiceForPagination[
                                                              index]
                                                          .serviceCategoryId!;

                                                  editProfileController
                                                          .servicePriceController
                                                          .text =
                                                      editProfileController
                                                          .lawyerProfileServiceForPagination[
                                                              index]
                                                          .price
                                                          .toString();
                                                });
                                              },
                                              buttonIcon: Icons.edit,
                                              buttonTextStyle: AppTextStyles
                                                  .buttonTextStyle2,
                                              borderRadius: 8,
                                              iconSize: 18,
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          SizedBox(
                                            width: 40.w,
                                            height: 26.h,
                                            child: ButtonWidgetFive(
                                              onTap: () {
                                                deleteMethod(
                                                    context,
                                                    "$addEditUserProfileServiceURL/${editProfileController.lawyerProfileServiceForPagination[index].id!}",
                                                    null,
                                                    true,
                                                    deleteUserProfileServiceDataRepo);
                                              },
                                              buttonIcon: Icons.delete,
                                              buttonTextStyle: AppTextStyles
                                                  .buttonTextStyle2,
                                              borderRadius: 8,
                                              iconSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 80.h),
                                child: Text(
                                  LanguageConstant.noDataFound.tr,
                                  style: AppTextStyles.bodyTextStyle10,
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
