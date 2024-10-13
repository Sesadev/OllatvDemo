// import 'package:flutter/material.dart';
//
// class CustomInputField extends StatelessWidget {
//   final String labelText;
//   final String hintText;
//   final TextEditingController controller;
//   final Color borderColor;
//
//   const CustomInputField({
//     required this.labelText,
//     required this.hintText,
//     required this.controller,
//     this.borderColor = Colors.grey, // Default border color is grey
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       style: const TextStyle(
//         color: Colors.black, // Text color when the user types
//         fontSize: 16,        // Set the font size for the input text
//       ),
//       decoration: InputDecoration(
//         labelText: labelText,
//         labelStyle: const TextStyle(
//           color: Color(0xFF6054A5), // Color for the label
//           fontSize: 16,  // Font size for the label text
//         ),
//         hintText: hintText,
//         hintStyle: const TextStyle(
//           color: Colors.grey,  // Hint text color
//           fontSize: 14,        // Smaller font size for the hint text
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           borderSide: BorderSide(color: borderColor), // Border color
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           borderSide: BorderSide(color: borderColor), // Border color when focused
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

// Enum to define validation types
enum InputType {
  normal,
  email,
  phone,
  emailOrPhone,
}

class CustomInputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final Color borderColor;
  final InputType inputType;

  const CustomInputField({
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.borderColor = Colors.grey, // Default border color is grey
    this.inputType = InputType.normal, // Default input type is normal
  });

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  String? errorText; // To display error messages
  bool _hasFocused = false; // To check if the field has been focused at least once

  // Validate input based on the selected input type
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return null; // No validation for empty input, even on blur
    }

    // Handle different validation types
    switch (widget.inputType) {
      case InputType.email:
        if (!EmailValidator.validate(value)) {
          return 'Please enter a valid email address';
        }
        break;
      case InputType.phone:
        final phoneRegExp = RegExp(r'^[0-9]{10}$');
        if (!phoneRegExp.hasMatch(value)) {
          return 'Please enter a valid 10-digit phone number';
        }
        break;
      case InputType.emailOrPhone:
         if (!EmailValidator.validate(value)) {
          final phoneRegExp = RegExp(r'^[0-9]{10}$');
          if (!phoneRegExp.hasMatch(value)) {
            return 'Please enter a valid email or 10-digit phone number';
          }
        }

        break;
      case InputType.normal:
        break;
    }

    return null; // No errors if valid
  }

  // Method to trigger validation on text change
  void _onChanged(String value) {
    setState(() {
      errorText = validateInput(value);
    });
  }

  // Method to trigger validation when the field loses focus
  void _onFocusChange(bool hasFocus) {
    if (!hasFocus) {
      setState(() {
        _hasFocused = true; // Mark the field as having been focused at least once
        errorText = validateInput(widget.controller.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: _onFocusChange,
          child: TextField(
            controller: widget.controller,
            onChanged: _onChanged, // Trigger validation on text change
            style: const TextStyle(
              color: Colors.black, // Text color when the user types
              fontSize: 16,        // Set the font size for the input text
            ),
            decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: const TextStyle(
                color: Color(0xFF6054A5), // Color for the label
                fontSize: 16,  // Font size for the label text
              ),
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Colors.grey,  // Hint text color
                fontSize: 14,        // Smaller font size for the hint text
              ),
            //  errorText: errorText, // Show the error during typing as well
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: widget.borderColor), // Default border color
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: errorText == null ? widget.borderColor : Color(0xFFCB3294)), // Change border color to red if error exists
              ),
            ),
          ),
        ),
        if (errorText != null) // Display error text whenever there's an error
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              errorText!,
              style: const TextStyle(color: Color(0xFFCB3294), fontSize: 12),
            ),
          ),
      ],
    );
  }
}

