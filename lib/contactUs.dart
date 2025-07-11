import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';  // Import url_launcher
import 'package:font_awesome_flutter/font_awesome_flutter.dart';  // Import Font Awesome icons

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  // Function to launch URL
  Future<void> _launchURL(String url) async {
    final Uri _url = Uri.parse(Uri.encodeFull(url));  // Ensure URL is fully encoded
    if (await canLaunchUrl(_url)) {  // Use canLaunchUrl instead of canLaunch
      await launchUrl(_url);  // Use launchUrl instead of launch
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Contact Us',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF003925)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Contact Information
              const Text(
                'Phone Number:',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '011-39834195',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Social Media Links
              const Text(
                'Follow Us:',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Instagram
              GestureDetector(
                onTap: () {
                  _launchURL('https://www.instagram.com/afiqd.ham');  // Updated Instagram URL
                },
                child: Row(
                  children: const [
                    Icon(FontAwesomeIcons.instagram, size: 28, color: Colors.white),  // Instagram icon
                    SizedBox(width: 16),
                    Text('Instagram: @barberFiq', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Facebook
              GestureDetector(
                onTap: () {
                  _launchURL('https://www.facebook.com/barberFiq');
                },
                child: Row(
                  children: const [
                    Icon(FontAwesomeIcons.facebook, size: 28, color: Colors.white),  // Facebook icon
                    SizedBox(width: 16),
                    Text('Facebook: @barberFiq', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Twitter (X)
              GestureDetector(
                onTap: () {
                  _launchURL('https://twitter.com/barberFiq');
                },
                child: Row(
                  children: const [
                    Icon(FontAwesomeIcons.twitter, size: 28, color: Colors.white),  // Twitter icon
                    SizedBox(width: 16),
                    Text('X: @barberFiq', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
