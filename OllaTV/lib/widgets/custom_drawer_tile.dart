import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CustomDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String routeName;

  const CustomDrawerTile({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title,style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w400),),
       trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // Added arrow icon with correct color

      onTap: () {
        if(title == "Logout")
          {
            Alert(
              context: context,
              type: AlertType.none,
              title: "Logout Confirmation",
              desc: "Are you sure you want to logout?",
              buttons: [
                DialogButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.grey,
                ),
                DialogButton(
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    // Perform your logout logic here
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  color: Colors.red,
                ),
              ],
              style: AlertStyle(
                isCloseButton: false, // Remove close button
                titleStyle: TextStyle(
                  fontSize: 24, // Customize title font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Customize title color
                ),
                descStyle: TextStyle(
                  fontSize: 16, // Customize description font size
                  color: Colors.black87, // Customize description color
                ),
              ),
            ).show();
          }
        else
          {

          }
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}

