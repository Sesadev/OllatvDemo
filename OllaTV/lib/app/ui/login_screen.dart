// import 'package:flutter/material.dart';
// import 'package:ollatv/util/constant.dart';
// import 'package:ollatv/widgets/custom_input_field.dart';
// import 'package:ollatv/widgets/custom_button.dart';
//  import 'package:ollatv/widgets/rounded_container.dart';
//
// class LoginScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,  // Light background color
//       resizeToAvoidBottomInset: true,  // Adjust when keyboard appears
//       body: Stack(
//         children: [
//           // Tree-like header image
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               alignment: Alignment.topCenter,
//               decoration: const BoxDecoration(
//                 gradient: appGradient,  // Reuse the gradient
//               ),
//               child:FractionallySizedBox(
//                 widthFactor: 0.72,  // The image will take up 50% of the screen's width
//                 child: Image.asset(
//                   "assets/images/logo.png",
//                   fit: BoxFit.contain,  // Ensures the image keeps its aspect ratio
//                 ),
//               ),
//             ),
//           ),
//           // Rounded container for login form
//           RoundedContainer(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 20),
//                 Text(
//                   'Welcome Back!',
//                   style: TextStyle(
//                     fontSize: 28,  // Larger font size
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Login or Register now to create a OllaTV Account!',
//                   style: TextStyle(
//                     fontSize: 14,  // Slightly smaller font size for the description
//                     color: Colors.grey.shade600,  // Lighter color for the description
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 CustomInputField(
//                   labelText: 'Email or Phone Number*',
//                   hintText: 'Enter your email or phone number',
//                   controller: emailController,
//                   borderColor: Colors.grey.shade400,  // Subtle grey border color
//                 ),
//                 SizedBox(height: 20),
//                 CustomButton(
//                   text: 'Next',
//                   onPressed: () {
//                     // Define your "Next" button action here
//                   },
//                   backgroundColor: Colors.black,  // Black background
//                   textColor: Colors.white,  // White text on black button
//                   borderRadius: BorderRadius.circular(8.0),  // Fully rounded button
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(child: Divider(thickness: 1)),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                       child: Text('Or continue with'),
//                     ),
//                     Expanded(child: Divider(thickness: 1)),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                  Center(
//                   child: TextButton(
//                     onPressed: () {
//                       // Navigate to the registration screen
//                     },
//                     child: RichText(
//                       text: TextSpan(
//                         text: "Don't have an account? ",
//                         style: TextStyle(color: Colors.black),
//                         children: [
//                           TextSpan(
//                             text: 'Register',
//                             style: TextStyle(
//                               color: Colors.green,  // Green color for the "Register" link
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:ollatv/app/ui/otp_verification_screen.dart';
import 'package:ollatv/app/ui/register_screen.dart';
import 'package:ollatv/util/constant.dart';
import 'package:ollatv/widgets/custom_input_field.dart';
import 'package:ollatv/widgets/custom_button.dart';
import 'package:ollatv/widgets/rounded_container.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200, // Light background color
      resizeToAvoidBottomInset: true, // Adjust when keyboard appears
      body: Stack(
        children: [
          // Gradient background section with logo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35, // Set height for the top section
              decoration: const BoxDecoration(
                gradient: appGradient, // Reuse the gradient from your constant
              ),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.5, // The image will take up 50% of the screen's width
                  child: Image.asset(
                    "assets/images/logo.png",
                    color: Colors.white,
                    fit: BoxFit.contain, // Ensures the image keeps its aspect ratio
                  ),
                ),
              ),
            ),
          ),
          // Positioned RoundedContainer below the gradient
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3, // Position it right below the gradient
            left: 0,
            right: 0,
            child: RoundedContainer(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                   // const SizedBox(height: 10),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28, // Larger font size
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6054A5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    // Text(
                    //   'Login or Register now to create an OllaTV Account!',
                    //   style: TextStyle(
                    //     fontSize: 14, // Slightly smaller font size for the description
                    //     color: Colors.grey.shade600, // Lighter color for the description
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    const SizedBox(height: 30),
                    CustomInputField(
                      labelText: 'Email or Phone Number*',
                      hintText: 'Enter your email or phone number',
                      controller: emailController,
                      inputType: InputType.emailOrPhone,
                      borderColor: Colors.grey.shade400, // Subtle grey border color
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Next',
                      onPressed: () {
                        // Define your "Next" button action here
                        // Dismiss the keyboard
                        FocusScope.of(context).unfocus();

                        // Navigate to OTP Verification Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OTPVerificationScreen(phoneNumber: "+918455824093",)),
                        );
                      },
                      gradient: appGradient, // Black background
                      textColor: Colors.white, // White text on black button
                      borderRadius: BorderRadius.circular(8.0), // Fully rounded button
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 1)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Or continue with'),
                        ),
                        const Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          // Navigate to Register Screen when clicking "Register"
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) => RegisterScreen(), // Navigate to RegisterScreen
                          ));
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(
                                  color  :Color(0xFF6054A5),fontWeight: FontWeight.bold , // Green color for the "Register" link
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
