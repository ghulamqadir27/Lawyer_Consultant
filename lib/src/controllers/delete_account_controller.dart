import 'package:get/get.dart';

class DeleteAccountController extends GetxController {
  bool deleteAccountLoader = false;
  void updateDeleteAccountLoader(bool newValue) {
    deleteAccountLoader = newValue;
    update();
  }
}
