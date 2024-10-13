import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ollatv/app/ui/drawer_screen.dart';
import 'package:ollatv/util/constant.dart';
import 'package:ollatv/widgets/custom_button.dart';
import 'package:ollatv/widgets/rounded_container.dart';
import 'package:pinput/pinput.dart'; // Add the pinput package in pubspec.yaml
import 'package:get/get.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber; // Accept the phone number from login screen

  const OTPVerificationScreen({required this.phoneNumber, Key? key}) : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  int _remainingTime = 30; // 1 minute 45 seconds
  Timer? _timer;
  bool _isResendAllowed = false;
  bool _isOtpValid = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // Start the countdown timer
  void _startTimer() {
    _isResendAllowed = false;
    _timer?.cancel(); // Cancel any existing timer
    setState(() {
      _remainingTime = 105; // Reset to 1 minute 45 seconds
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isResendAllowed = true; // Allow resend after time expires
        });
      }
    });
  }

  // Resend OTP action
  void _resendOTP() {
    // Logic to resend OTP code goes here
    print('Resent OTP Code');
    _startTimer(); // Restart the timer when the code is resent
  }

  // Validate OTP logic
  void _validateOTP(String enteredOTP) {
    setState(() {
      _isOtpValid = enteredOTP == "123456"; // Hardcoded OTP for example; use actual validation in real case
    });
    if (_isOtpValid) {
      // Navigate to the dashboard
    //  Navigator.of(context).pushReplacementNamed('/dashboard'); // Navigate to OTP Verification Screen
      Get.offAll(MyHomePage(), transition: Transition.rightToLeftWithFade);

    } else {
      _showErrorDialog("Invalid OTP");
    }
  }

  // Show error dialog for invalid OTP
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Cancel action to go back
  void _cancelAction() {
    Navigator.of(context).pop();
  }

  // Navigate to registration
  void _goToRegistration() {
    Navigator.of(context).pushNamed('/register');
  }

  // Format the remaining time as MM:SS
  String _formattedTime() {
    int minutes = _remainingTime ~/ 60;
    int seconds = _remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Dispose of the timer when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background image section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: const BoxDecoration(
                gradient: appGradient,
              ),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Image.asset(
                    "assets/images/logo.png", // Replace with your OTP image asset
                    color: Colors.white,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // RoundedContainer for OTP form
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: keyboardHeight),
              child: RoundedContainer(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Verify OTP',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6054A5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      // Dynamically display the phone number
                      Text(
                        'We have sent an OTP Code on ${widget.phoneNumber}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      // OTP Input Field
                      Pinput(
                        controller: _otpController,
                        length: 6,
                        defaultPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                        ),
                        onCompleted: (pin) {
                          print('Entered OTP: $pin');
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _remainingTime > 0
                            ? 'Remaining Time ${_formattedTime()}'
                            : 'Time Expired',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _isResendAllowed ? _resendOTP : null,
                        child: Text(
                          'Resend Code',
                          style: TextStyle(
                            fontSize: 16,
                            color: _isResendAllowed ? Colors.blue : Colors.grey,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Login Button
                      CustomButton(
                        text: 'Login',
                        onPressed: () {
                          _validateOTP(_otpController.text);
                        },
                        gradient: appGradient,
                        textColor: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: _cancelAction,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: _goToRegistration,
                          child: RichText(
                            text: const TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: 'Register',
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
          ),
        ],
      ),
    );
  }
}
