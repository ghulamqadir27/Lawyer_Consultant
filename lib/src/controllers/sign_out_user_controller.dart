import 'package:get/get.dart';
import '../models/sign_out_model.dart';

class SignOutUserController extends GetxController {
  SignOutModel signOutModel = SignOutModel();
  bool signOutLoaderController = false;

  void updateSignOutLoaderController(bool newValue) {
    signOutLoaderController = newValue;
    update();
  }
}
