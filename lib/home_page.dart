import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For jsonDecode
import 'package:shared_preferences/shared_preferences.dart';  // For SharedPreferences

// Import the pages
import 'service_page.dart';    // Service page navigation
import 'booking.dart';         // Booking page navigation
import 'profile.dart';         // Profile page navigation

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _fullName = "";  // Variable to store full name

  // Function to fetch full name from the server (get_user.php)
  void _getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString('mobile');

    if (mobile != null) {
      try {
        final response = await http.post(
          Uri.parse('http://10.41.104.9/barberApp/get_user.php'),
          body: {'mobile': mobile},
        );

        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['status'] == 'success') {
          setState(() {
            _fullName = responseData['full_name'];
          });
        } else {
          print("Error: ${responseData['message']}");
        }
      } catch (e) {
        print('Error fetching full name: $e');
      }
    } else {
      print('No mobile found in SharedPreferences');
    }
  }

  @override
  void initState() {
    super.initState();
    _getFullName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'BarberFlq',
          style: TextStyle(fontFamily: 'GoogleFont', fontSize: 24),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.group),
              onPressed: () {
                // Handle About Us button action
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // User's welcome message
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                  AssetImage('assets/your_avatar.png'),
                ),
                SizedBox(width: 10),
                Text(
                  'Welcome Back, $_fullName!',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Video player container
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image:
                AssetImage('assets/your_video_thumbnail.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white),
                    Text(
                      'Watch Video',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // (Buttons removed)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cut),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ServicePage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BookingPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfilePage()),
              );
              break;
            default:
            // Home (do nothing)
              break;
          }
        },
      ),
    );
  }
}
