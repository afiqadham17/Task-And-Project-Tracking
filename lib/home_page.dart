import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For jsonDecode
import 'package:shared_preferences/shared_preferences.dart';  // For SharedPreferences

// Import the pages
import 'service_page.dart';    // Service page navigation
import 'booking.dart';         // Booking page navigation
import 'profile.dart';         // Profile page navigation
import 'about_us_page.dart';   // Import About Us Page

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
        print('Response Body: ${response.body}');  // Debugging the response

        final responseData = jsonDecode(response.body);

        // Check the status and handle the response accordingly
        if (response.statusCode == 200 && responseData['status'] == 'success') {
          setState(() {
            _fullName = responseData['full_name'];  // Update the full name state
          });
        } else {
          print("Error: ${responseData['message']}");  // Debugging error messages
        }
      } catch (e) {
        print('Error fetching full name: $e');  // Catch and log any exceptions
      }
    } else {
      print('No mobile found in SharedPreferences');  // Handle case where mobile is not found
    }
  }

  @override
  void initState() {
    super.initState();
    _getFullName();  // Fetch the full name when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/barber.png',  // Path to your logo image
          height: 40,  // Adjust the size of the logo image
        ),
        actions: [], // Removed the icons from the actions section
      ),
      body: Column(
        children: [
          // Image Container - Placed below the AppBar
          Container(
            width: double.infinity,
            height: 400,  // Increased height to make the image larger
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage('assets/logo.png'), // Correct image path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // "About Us" Button with increased size
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the About Us Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00603F),
                padding: const EdgeInsets.symmetric(vertical: 20),  // Increased vertical padding for height
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                minimumSize: Size(double.infinity, 60),  // Set width to full screen and height to 60
              ),
              child: const Text(
                'About Us',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
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
                MaterialPageRoute(builder: (context) => const ServicePage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
