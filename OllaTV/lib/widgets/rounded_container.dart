import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;

  const RoundedContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,  // Ensure the container is aligned to the bottom
      child: Container(
        width: MediaQuery.of(context).size.width - 30,  // Full width
       // height: MediaQuery.of(context).size.height - 300,
        height: MediaQuery.of(context).size.height * 0.7, // Full height minus the header height
        decoration: BoxDecoration(
          color: Colors.white,  // Background color
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),  // Top-left rounded corner
            topRight: Radius.circular(24), // Top-right rounded corner
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x2E000000),  // Light black shadow with transparency
              blurRadius: 20,  // The blur effect of the shadow
              spreadRadius: -6,  // Negative spread for a subtle shadow
              offset: Offset(0, 0),  // Shadow positioning (no offset)
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),  // Padding for content inside the container
          child: child,  // This is where the inner content of the container goes
        ),
      ),
    );
  }
}
