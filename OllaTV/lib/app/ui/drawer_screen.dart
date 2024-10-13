import 'package:ollatv/app/ui/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:ollatv/util/constant.dart'; // For the gradient background
import 'package:ollatv/widgets/custom_drawer_tile.dart'; // Import the custom drawer tile

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.Style2,            // Use this or adjust to your style preference
      menuScreen: DrawerMenu(),             // Drawer menu screen
      mainScreen: DashboardScreen(),        // Main screen (dashboard)
      borderRadius: 4.0,                   // Adjust this for roundness on the zoom
      showShadow: true,                     // Shadow for drawer
      angle: 0.0,                           // Setting angle to 0 to avoid zoom issues
      slideWidth: MediaQuery.of(context).size.width * 0.80,  // Adjust slide width (70% of the screen width)
      openCurve: Curves.fastOutSlowIn,      // Smooth opening animation
      closeCurve: Curves.bounceIn,          // Smooth closing animation
    );
  }
}

class DrawerMenu extends StatelessWidget {
  final String userName = "Jitendra Kumar Pradhan"; // Replace with dynamic data
  final String email = "pradhanjitu86@gmail.com"; // Replace with dynamic data
  final String phoneNumber = "+91 9876543210"; // Replace with dynamic data
  final String? profileImage; // Can be null if there's no profile image
  final String version = "v1.0.0"; // Replace with app version dynamically if needed

  DrawerMenu({this.profileImage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Removes padding around the drawer items
        children: <Widget>[
          // Custom top section for user profile with gradient background
          Container(
            height: 360, // Increased height for the header section
            decoration: const BoxDecoration(
            // gradient: appGradient,
              color: Colors.blueGrey// Reusing the app gradient from the login/OTP screen
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centers everything vertically
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,  // Ensures the border is circular
                    border: Border.all(
                      color: Colors.white,   // White border color
                      width: 4.0,            // 4-pixel border width
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 45, // Adjust size as needed
                    child: profileImage != null
                        ? ClipOval(
                      child: Image.network(
                        profileImage!,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Text(
                      _getUserInitials(userName),
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Moved the avatar lower
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phoneNumber,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // Drawer tiles wrapped in a Container to look card-like
          Container(
            margin: const EdgeInsets.only(left: 16, top: 10, right: 30, bottom: 10), //
          //  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20), // Adjusting horizontal margin for narrower width
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white, // White background for the container
              borderRadius: BorderRadius.circular(12), // Rounded corners
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey, // Shadow color
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                CustomDrawerTile(
                  title: 'Dashboard',
                  icon: Icons.dashboard,
                  iconColor: Colors.blueGrey,
                  routeName: '/dashboard',
                ),
                const Divider(height: 1, color: Colors.grey),
                CustomDrawerTile(
                  title: 'Edit Profile',
                  icon: Icons.person,
                  iconColor: Colors.blueGrey,
                  routeName: '/profile',
                ),
                const Divider(height: 1, color: Colors.grey),
                CustomDrawerTile(
                  title: 'About Us',
                  icon: Icons.info,
                  iconColor: Colors.blueGrey,
                  routeName: '/about',
                ),
                const Divider(height: 1, color: Colors.grey),
                CustomDrawerTile(
                  title: 'Terms & Conditions',
                  icon: Icons.description,
                  iconColor: Colors.blueGrey,
                  routeName: '/terms',
                ),
                const Divider(height: 1, color: Colors.grey),
                CustomDrawerTile(
                  title: 'Logout',
                  icon: Icons.exit_to_app,
                  iconColor: Colors.blueGrey,
                  routeName: '/signout',
                ),
                const Divider(height: 1, color: Colors.grey),

                // App version inside the container
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'App Version: $version',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to extract user initials if no profile image is available
  String _getUserInitials(String name) {
    if (name.isEmpty) return "";
    List<String> nameParts = name.split(" ");
    String initials = "";
    if (nameParts.length == 1) {
      initials = nameParts[0][0];
    } else {
      initials = nameParts[0][0] + nameParts[1][0];
    }
    return initials.toUpperCase();
  }
}



