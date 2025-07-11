import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'booking_details.dart';  // Import for BookingDetailsPage
import 'home_page.dart';  // Ensure HomePage is available

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool _isLoading = false;
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();  // Fetch bookings when the page loads
  }

  // Simulate fetching bookings data (one dummy data)
  Future<void> _fetchBookings() async {
    setState(() {
      _isLoading = true;
    });

    // Simulated delay to mimic fetching data from the backend
    await Future.delayed(const Duration(seconds: 2));

    // Dummy data (one booking entry)
    final data = {
      'status': 'success',
      'bookings': [
        {
          'id': 27,
          'booking_date': '2025-07-11',
          'booking_time': '20:00',
          'services': 'Haircut, Beard Grooming',
          'total': 45.0,
        },
      ],
    };

    if (data['status'] == 'success') {
      setState(() {
        bookings = (data['bookings'] as List<dynamic>).map<Map<String, dynamic>>((booking) {
          return {
            'id': booking['id'],
            'date': booking['booking_date'],
            'time': booking['booking_time'],
            'services': booking['services'],
            'total': booking['total'],
          };
        }).toList();
        _isLoading = false;  // Set loading to false after fetching
      });
    } else {
      _showError('Failed to load bookings');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $msg')),
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Booking History',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF003925)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Show loading indicator while fetching
              _isLoading
                  ? const Center(child: CircularProgressIndicator())  // Show loading indicator
                  : Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final b = bookings[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailsPage(
                                bookingId: b['id'].toString(), // Pass the booking ID to BookingDetailsPage
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF00603F),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Column(
                            children: [
                              // Top row: date & time
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${b['date']} ${b['time']}',
                                        style: const TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(color: Colors.white, thickness: 1),
                              // Services & Total
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            Text('Services',
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                            SizedBox(height: 8),
                                            Text('Total Amount',
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(b['services'], style: const TextStyle(color: Colors.white, fontSize: 16)),
                                            const SizedBox(height: 8),
                                            // Ensure 'total' is converted to String
                                            Text(b['total'].toString(), style: const TextStyle(color: Colors.white, fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
