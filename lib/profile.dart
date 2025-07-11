import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'booking_details.dart';  // Import for BookingDetailsPage
import 'contactUs.dart';
import 'feedback.dart';
import 'home_page.dart';
import 'my_profile.dart';  // Ensure HomePage is available

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fullName = '';
  bool isLoading = true; // Show loading indicator initially

  @override
  void initState() {
    super.initState();
    fetchUserFullName();
  }

  // Function to fetch user full name from the database (replaced with dummy data)
  Future<void> fetchUserFullName() async {
    // Simulated delay to mimic data fetching
    await Future.delayed(const Duration(seconds: 2));

    // Dummy data for the full name
    setState(() {
      fullName = 'Afiq Adham'; // Set the dummy name
      isLoading = false; // Data has been fetched, stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF003925)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                // User full name
                isLoading
                    ? const CircularProgressIndicator()  // Show loading spinner while fetching data
                    : Text(
                  fullName.isEmpty ? 'No Name Available' : fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // View Profile Section (Tappable)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyProfilePage()),
                    );
                  },
                  child: const Text(
                    'View Profile',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),

                const SizedBox(height: 32),

                // Help & Settings Section
                const Text(
                  'Help & Settings',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Feedback Section
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FeedbackPage()),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.thumb_up, size: 28, color: Color(0xFF00603F)),
                      SizedBox(width: 16),
                      Text('Feedback', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Contact Us Section
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ContactUsPage()),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.call, size: 28, color: Color(0xFF00603F)),
                      SizedBox(width: 16),
                      Text('Contact Us', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
