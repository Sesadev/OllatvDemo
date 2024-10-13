// import 'package:flutter/material.dart';
//
// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final Color backgroundColor;
//   final Color textColor;
//   final BorderRadius borderRadius;
//
//   const CustomButton({
//     required this.text,
//     required this.onPressed,
//     this.backgroundColor = Colors.blue,  // Default background color (can be overridden)
//     this.textColor = Colors.white,       // Default text color
//     this.borderRadius = const BorderRadius.all(Radius.circular(2.0)),  // Default border radius
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 46,  // Fixed height for the button
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColor,  // Set the background color
//          // padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),  // Padding from Figma
//           shape: RoundedRectangleBorder(
//             borderRadius: borderRadius,  // Apply custom border radius
//           ),
//           elevation: 2,  // Shadow for the button
//         ),
//         onPressed: onPressed,
//         child: Text(
//           text,
//           style: TextStyle(
//             color: textColor,  // Set the text color
//             fontSize: 16,      // Font size for the button text
//             fontWeight: FontWeight.bold,  // Bold text
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient? gradient; // New: Accept a gradient as an optional parameter
  final Color textColor;
  final BorderRadius borderRadius;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.gradient,  // Optional gradient for the background
    this.textColor = Colors.white,  // Default text color
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),  // Default border radius
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,  // Fixed height for the button
      decoration: BoxDecoration(
        gradient: gradient,  // Apply the gradient if provided
        borderRadius: borderRadius,  // Rounded corners for the button
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),  // Shadow positioning
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Make button background transparent to show the gradient
          shadowColor: Colors.transparent, // Remove the button shadow
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,  // Apply custom border radius
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,  // Set the text color
            fontSize: 16,  // Font size for the button text
            fontWeight: FontWeight.bold,  // Bold text
          ),
        ),
      ),
    );
  }
}
