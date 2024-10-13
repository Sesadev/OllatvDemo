import 'package:flutter/material.dart';
import 'package:ollatv/util/constant.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed; // Callback for back button
  final VoidCallback? onMenuPressed; // Callback for menu button
  final bool showBackButton; // To show back button
  final bool showMenuButton; // To show menu button

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.onBackPressed, // Add back button callback
    this.onMenuPressed, // Add menu button callback
    this.showBackButton = false, // Show back button by default
    this.showMenuButton = false, // Show menu button by default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: _buildLeadingIcon(context),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.white,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: appGradient
        ),
      ),
      centerTitle: true,
      elevation: 5,
      actions: actions, // Optional actions for AppBar
    );
  }

  // Function to build the leading icon based on conditions
  Widget? _buildLeadingIcon(BuildContext context) {
    if (showBackButton) {
      return IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackPressed ?? () {
          Navigator.of(context).pop(); // Default go back behavior
        },
      );
    } else if (showMenuButton) {
      return IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: onMenuPressed ?? () {
          Scaffold.of(context).openDrawer(); // Default open drawer behavior
        },
      );
    } else {
      return null; // No leading icon
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


/*
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed; // Callback for back button
  final bool showBackButton; // Boolean to control the back button visibility

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.onBackPressed, // Add back button callback
    this.showBackButton = true, // Show back button by default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
        icon: Icon(Icons.arrow_back,color: Colors.white,), // Custom back button icon
        onPressed: onBackPressed ?? () {
          Navigator.of(context).pop(); // Default behavior (go back)
        },
      )
          : null, // Hide the back button when `showBackButton` is false
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.white,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors:  [Color(0xFF6054A5), Color(0xFFCB3294)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.9],
          ),
        ),
      ),
      centerTitle: true,
      elevation: 5,
      actions: actions, // Optional actions for AppBar
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

 */