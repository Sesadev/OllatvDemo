// import 'package:flutter/material.dart';
// import 'package:ollatv/util/constant.dart';
// import 'package:ollatv/widgets/custom_input_field.dart';
// import 'package:ollatv/widgets/custom_button.dart';
// import 'package:ollatv/widgets/rounded_container.dart';
//
// class RegisterScreen extends StatelessWidget {
//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     double keyboardHeight = MediaQuery.of(context).viewInsets.bottom; // Detect keyboard height
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       resizeToAvoidBottomInset: true, // Adjust when keyboard appears
//       body: Stack(
//         children: [
//           // Gradient background section (this will not move)
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.35,
//               decoration: const BoxDecoration(
//                 gradient: appGradient, // Gradient background
//               ),
//               child: Center(
//                 child: FractionallySizedBox(
//                   widthFactor: 0.5,
//                   child: Image.asset(
//                     "assets/images/logo.png",
//                     color: Colors.white,
//                     fit: BoxFit.contain, // Ensures the image keeps its aspect ratio
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // The container that moves up with the keyboard
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: AnimatedPadding(
//               duration: const Duration(milliseconds: 200),
//               padding: EdgeInsets.only(bottom: keyboardHeight), // Adjust padding based on keyboard
//               child: SingleChildScrollView(
//                 // This ensures the container can be scrolled when necessary
//                 child: RoundedContainer(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       mainAxisSize: MainAxisSize.min, // Ensures the container doesn't occupy excess space
//                       children: [
//                         const Text(
//                           'Create Your Account',
//                           style: TextStyle(
//                             fontSize: 28, // Larger font size
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF6054A5),
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 30),
//                         // Full Name Text Field
//                         CustomInputField(
//                           labelText: 'Full Name*',
//                           hintText: 'Enter your full name',
//                           controller: fullNameController,
//                           inputType: InputType.normal, // Normal text field
//                           borderColor: Colors.grey.shade400, // Subtle grey border color
//                         ),
//                         const SizedBox(height: 20),
//                         // Phone Number Text Field
//                         CustomInputField(
//                           labelText: 'Phone Number*',
//                           hintText: 'Enter your phone number',
//                           controller: phoneNumberController,
//                           inputType: InputType.phone, // Phone number field
//                           borderColor: Colors.grey.shade400,
//                         ),
//                         const SizedBox(height: 20),
//                         // Email Text Field (Optional)
//                         CustomInputField(
//                           labelText: 'Email (Optional)',
//                           hintText: 'Enter your email',
//                           controller: emailController,
//                           inputType: InputType.email, // Email field
//                           borderColor: Colors.grey.shade400,
//                         ),
//                         const SizedBox(height: 20),
//                         // Register Button
//                         CustomButton(
//                           text: 'Register',
//                           onPressed: () {
//                             // Define your registration logic here
//                           },
//                           gradient: appGradient, // Gradient background
//                           textColor: Colors.white, // White text
//                           borderRadius: BorderRadius.circular(8.0), // Rounded button
//                         ),
//                         const SizedBox(height: 20),
//                         Center(
//                           child: TextButton(
//                             onPressed: () {
//                               // Navigate to the Login screen
//                               Navigator.of(context).pop(); // Go back to the previous screen
//                             },
//                             child: RichText(
//                               text: const TextSpan(
//                                 text: 'Already have an account? ',
//                                 style: TextStyle(color: Colors.black),
//                                 children: [
//                                   TextSpan(
//                                     text: 'Login',
//                                     style: TextStyle(
//                                       color: Color(0xFF6054A5),
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:ollatv/util/constant.dart';
import 'package:ollatv/widgets/custom_input_field.dart';
import 'package:ollatv/widgets/custom_button.dart';
import 'package:ollatv/widgets/rounded_container.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom; // Detect keyboard height

    // Adjust the top position of the container when the keyboard appears
    double containerTop = keyboardHeight > 0
        ? screenHeight * 0.25 - keyboardHeight * 0.25  // When the keyboard is up
        : screenHeight * 0.3;  // Default position when keyboard is not visible

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      resizeToAvoidBottomInset: true, // Adjust when keyboard appears
      body: Stack(
        children: [
          // Gradient background section (this will not move)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.35,
              decoration: const BoxDecoration(
                gradient: appGradient, // Gradient background
              ),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Image.asset(
                    "assets/images/logo.png",
                    color: Colors.white,
                    fit: BoxFit.contain, // Ensures the image keeps its aspect ratio
                  ),
                ),
              ),
            ),
          ),
          // Animated Container that moves up with the keyboard
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            curve: Curves.decelerate,
            top: containerTop, // Adjust top based on keyboard visibility
            left: 0,
            right: 0,
            child: RoundedContainer(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Create Your Account',
                      style: TextStyle(
                        fontSize: 28, // Larger font size
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6054A5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    // Full Name Text Field
                    CustomInputField(
                      labelText: 'Full Name*',
                      hintText: 'Enter your full name',
                      controller: fullNameController,
                      inputType: InputType.normal, // Normal text field
                      borderColor: Colors.grey.shade400, // Subtle grey border color
                    ),
                    const SizedBox(height: 20),
                    // Phone Number Text Field
                    CustomInputField(
                      labelText: 'Phone Number*',
                      hintText: 'Enter your phone number',
                      controller: phoneNumberController,
                      inputType: InputType.phone, // Phone number field
                      borderColor: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    // Email Text Field (Optional)
                    CustomInputField(
                      labelText: 'Email (Optional)',
                      hintText: 'Enter your email',
                      controller: emailController,
                      inputType: InputType.email, // Email field
                      borderColor: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    // Register Button
                    CustomButton(
                      text: 'Register',
                      onPressed: () {
                        // Define your registration logic here
                      },
                      gradient: appGradient, // Gradient background
                      textColor: Colors.white, // White text
                      borderRadius: BorderRadius.circular(8.0), // Rounded button
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          // Navigate to the Login screen
                          Navigator.of(context).pop(); // Go back to the previous screen
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: Color(0xFF6054A5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
