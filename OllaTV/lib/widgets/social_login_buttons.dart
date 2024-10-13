import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: 'assets/images/facebook_icon.png',
          backgroundColor: Colors.grey.shade200,  // Light gray background for the container
          onTap: () {
            // Handle Facebook login
          },
        ),
        SizedBox(width: 20),
        _buildSocialButton(
          icon: 'assets/images/google_icon.png',
          backgroundColor: Colors.grey.shade200,
          onTap: () {
            // Handle Google login
          },
        ),
        SizedBox(width: 20),
        _buildSocialButton(
          icon: 'assets/images/apple_icon.png',
          backgroundColor: Colors.grey.shade200,
          onTap: () {
            // Handle Apple login
          },
        ),
      ],
    );
  }

  // Reusable widget to build a social login button with a circular light gray background
  Widget _buildSocialButton({
    required String icon,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.0),  // Padding inside the light gray circle
        decoration: BoxDecoration(
          color: backgroundColor,  // Light gray background
          shape: BoxShape.circle,  // Circular shape for the container
        ),
        child: SizedBox(
          width: 40,  // Icon size
          height: 40,
          child: Image.asset(icon),  // Icon itself with no background color
        ),
      ),
    );
  }
}
