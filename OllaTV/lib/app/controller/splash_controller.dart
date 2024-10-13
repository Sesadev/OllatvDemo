import 'dart:async';
import 'package:get/get.dart';
import 'package:ollatv/app/ui/drawer_screen.dart';
import 'package:ollatv/app/ui/edit_profile_screen.dart';
import 'package:ollatv/app/ui/login_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // Delay 3 seconds, then call redirectScreen
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  redirectScreen() async {
    try {
      // Uncomment and modify this logic if login handling is required
      // bool isLogin = await FireStoreUtils.isLogin();
      // if (isLogin == true) {
     //    Get.offAll(  LoginScreen(), transition: Transition.rightToLeftWithFade);
      // } else {
       Get.offAll(MyHomePage(), transition: Transition.rightToLeftWithFade);
     // Get.offAll(EditProfileScreen(), transition: Transition.rightToLeftWithFade);

      // }
    } catch (e) {
      // Log any errors if navigation fails
      print("Error navigating to the next screen: $e");
    }
  }
}
