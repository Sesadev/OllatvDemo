import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ollatv/util/constant.dart';
import 'package:ollatv/widgets/custom_input_field.dart';
import 'package:ollatv/widgets/custom_button.dart';
import 'package:ollatv/widgets/rounded_container.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _profileImage; // To store the profile image
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Function to handle profile image picking
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Function to show bottom sheet for picking image
  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
          // Gradient background section with back button and circular avatar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.35,
              decoration: const BoxDecoration(
                gradient: appGradient, // Gradient background
              ),
              child: Stack(
                children: [
                  // Back button at the top-left corner
                  Positioned(
                    top: 40, // Adjust for proper spacing
                    left: 16,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.of(context).pop(); // Navigate back
                      },
                    ),
                  ),
                  // Circular avatar in the center
                  Center(
                    child: GestureDetector(
                      onTap: () => _showPicker(context), // Open image picker on tap
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : null,
                            child: _profileImage == null
                                ? Icon(Icons.person, size: 60, color: Colors.white)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                      'Edit Your Profile',
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
                    // Save Button
                    CustomButton(
                      text: 'Save',
                      onPressed: () {
                        // Save logic
                      },
                      gradient: appGradient, // Gradient background
                      textColor: Colors.white, // White text
                      borderRadius: BorderRadius.circular(8.0), // Rounded button
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
