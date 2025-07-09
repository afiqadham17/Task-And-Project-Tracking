import 'package:flutter/material.dart';
import 'package:barber_booking_app/my_profile.dart';  // make sure this matches your pubspec name

/// Profile overview page
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
        // ensure gradient covers entire screen
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
                // User header: avatar + tappable name/View Profile
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/profile_placeholder.png'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MyProfilePage()),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Afiq Adham',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'View Profile',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // General Section
                const Text(
                  'General',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () { /* TODO: My Addresses */ },
                  child: Row(
                    children: const [
                      Icon(Icons.location_on, size: 28, color: Colors.redAccent),
                      SizedBox(width: 16),
                      Text('My Addresses', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Help & Settings Section
                const Text(
                  'Help & Settings',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () { /* TODO: Notifications */ },
                  child: Row(
                    children: const [
                      Icon(Icons.notifications, size: 28, color: Color(0xFF00603F)),
                      SizedBox(width: 16),
                      Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () { /* TODO: Feedback */ },
                  child: Row(
                    children: const [
                      Icon(Icons.thumb_up, size: 28, color: Color(0xFF00603F)),
                      SizedBox(width: 16),
                      Text('Feedback', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () { /* TODO: Contact Us */ },
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