import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';

import '../config/app_text_styles.dart';

import '../controllers/all_languages_controller.dart';
import '../controllers/general_controller.dart';
import '../widgets/appbar_widget.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int? value;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetAllLanguagesController>(
        builder: (getAllLanguagesController) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBarWidget(
            leadingIcon: 'assets/icons/Expand_left.png',
            leadingOnTap: () {
              Get.back();
            },
            richTextSpan: TextSpan(
              text: LanguageConstant.languages.tr,
              style: AppTextStyles.appbarTextStyle2,
              children: <TextSpan>[],
            ),
          ),
        ),
        body: getAllLanguagesController.getAllLanguagesLoader
            ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 0.h, 18.w, 18.h),
                  child: ListView(
                    shrinkWrap: true,
                    children: List.generate(
                        Get.find<GeneralController>().localeList.length,
                        (index) {
                      value = Get.find<GeneralController>()
                          .storageBox
                          .read('languageIndex');

                      return RadioListTile(
                        value: index,
                        groupValue: value,
                        onChanged: (ind) {
                          setState(() {
                            value = ind;
                            Get.find<GeneralController>().storageBox.write(
                                'languageCode',
                                Get.find<GeneralController>()
                                    .localeList[index]
                                    .languageCode);
                            Get.find<GeneralController>().storageBox.write(
                                'countryCode',
                                Get.find<GeneralController>()
                                    .localeList[index]
                                    .countryCode);
                            Get.find<GeneralController>()
                                .storageBox
                                .write('languageIndex', index);
                            Get.find<GeneralController>().selectedLocale =
                                Get.find<GeneralController>().localeList[index];
                            var locale = Locale(
                                Get.find<GeneralController>()
                                    .localeList[index]
                                    .languageCode,
                                Get.find<GeneralController>()
                                    .localeList[index]
                                    .countryCode);
                            Get.updateLocale(locale);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '(${Get.find<GeneralController>().storageBox.read('languageCode')} - ${Get.find<GeneralController>().storageBox.read('countryCode')}) ${LanguageConstant.languageHasBeenSelected.tr}',
                                  style: AppTextStyles.bodyTextStyle18,
                                ),
                              ),
                            );
                            print(
                                "${Get.find<GeneralController>().storageBox.read('languageCode')} LANGCODE");
                          });
                        },
                        visualDensity:
                            const VisualDensity(vertical: -1, horizontal: 4),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: -4, vertical: -2),
                        activeColor: AppColors.primaryColor,
                        // onChanged: (ind) => setState(() => value = ind),

                        title: Row(
                          children: [
                            // Get.find<GeneralController>()
                            //         .localeList[index]
                            //         .image
                            //         .isEmpty
                            //     ?
                            //     ClipRRect(
                            //         borderRadius: BorderRadius.circular(8.r),
                            //         child: Image.asset(
                            //           scale: 1.h,
                            //           'assets/images/US.png',
                            //           fit: BoxFit.cover,
                            //           height: 30.h,
                            //           width: 50.w,
                            //         ))
                            //     :
                            Image.network(
                              scale: 1.h,
                              '$mediaUrl/assets/flags/${Get.find<GeneralController>().localeList[index].languageCode}.png',
                              fit: BoxFit.cover,
                              height: 30.h,
                              width: 50.w,
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              Get.find<GeneralController>()
                                  .localeList[index]
                                  .name,
                              style: AppTextStyles.bodyTextStyle17,
                            ),
                          ],
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                      );
                    }),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
      );
    });
  }
}
