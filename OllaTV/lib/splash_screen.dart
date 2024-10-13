import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollatv/app/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            color: Colors.white,
            child: Center(
              child:FractionallySizedBox(
              widthFactor: 0.72,  // The image will take up 50% of the screen's width
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,  // Ensures the image keeps its aspect ratio
              ),
            ),
          ),
          ),
        );
      },
    );
  }
}
