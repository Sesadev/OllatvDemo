import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:ollatv/app/ui/chat_screen.dart';
import 'package:ollatv/app/ui/video_screen/join_channel_video.dart';
import 'package:ollatv/util/constant.dart'; // For the gradient background
import 'package:intl/intl.dart'; // For date formatting

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Updated Header Section with gradient background and search field
          Container(
            decoration: const BoxDecoration(
             gradient: appGradient, // Use the gradient background
             // color: Colors.blueGrey
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20), // Add padding for top spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        ZoomDrawer.of(context)?.toggle(); // Toggle the drawer
                      },
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.videocam, color: Colors.white),
                          onPressed: () {
                            // Action for video button
                            Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) => const JoinChannelVideo(),
                                )
                             );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications, color: Colors.white),
                          onPressed: () {
                            // Action for notification icon
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome, Krishna Rathore!',
                  textAlign: TextAlign.center,  // This will center the text
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,

                  ),
                ),
                const SizedBox(height: 20),
                // Search bar without search button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Rest of your dashboard content (ListView.builder in this case)
          // Rest of your dashboard content (ListView.builder in this case)
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Example list of agents
              itemBuilder: (context, index) {
                DateTime lastChatDate = DateTime.now().subtract(Duration(days: index)); // Simulate last chat time for demo
                String formattedTime = _getFormattedTime(lastChatDate);

                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 30, // Larger size for user icons
                    child:   Icon(
                      Icons.person, // Replace with your desired icon
                      color: Colors.white, // Icon color
                      size: 30, // Icon size
                    ),
                  ),
                  title: Text(
                    'Agent $index',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('Chat with user Agent $index'),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [

                       Text(
                        formattedTime, // Show formatted last chat time or date
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle chat tap, navigate to chat details
                    Navigator.pushNamed(context,
                      ChatScreen.routeName,
                      arguments: {
                      'contactName': 'Agent $index',
                      'userId': 'Agent $index'
                      }
                    );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ChatScreen()),
                    // );
                  },
                );
              },
            ),
          ),        ],
      ),
    );
  }
  // Helper function to format the time/date
  String _getFormattedTime(DateTime date) {
    DateTime now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      // If it's today, show time
      return DateFormat('hh:mm a').format(date);
    } else {
      // Otherwise, show date
      return DateFormat('dd/MM/yy').format(date);
    }
  }
}

