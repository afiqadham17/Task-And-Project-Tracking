import 'package:flutter/material.dart';
import 'dart:convert';

import 'service.dart';
import 'booking.dart'; // for BookingPage

class BookingDetailsPage extends StatefulWidget {
  final String bookingId;
  const BookingDetailsPage({Key? key, required this.bookingId})
      : super(key: key);

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  bool _loading = false;
  String _mobile = '';
  DateTime? _date;
  TimeOfDay? _time;
  List<Service> _services = [];

  @override
  void initState() {
    super.initState();
    _fetchBooking(); // Fetch booking data with dummy data
  }

  Future<void> _fetchBooking() async {
    setState(() {
      _loading = true;
    });

    // Dummy data to simulate fetching from a server
    await Future.delayed(const Duration(seconds: 2)); // Simulate a delay

    // Simulated booking data
    final data = {
      'status': 'success',
      'booking': {
        'mobile': '0123456789',
        'booking_date': '2025-07-11',
        'booking_time': '20:00',
      },
      'services': [
        {'service_name': 'Haircut', 'price': 35.0},
        {'service_name': 'Beard Grooming', 'price': 10.0},
      ],
    };

    if (data['status'] == 'success') {
      final b = data['booking'] as Map<String, dynamic>;

      // Parse date and time
      final date = DateTime.parse(b['booking_date'] as String);
      final timeParts = (b['booking_time'] as String).split(':');
      final time = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));

      // Parse services
      final services = (data['services'] as List<dynamic>).map((s) {
        final name = s['service_name'] as String;
        final price = double.parse(s['price'].toString());
        return Service(name: name, price: price, icon: _iconForService(name));
      }).toList();

      setState(() {
        _mobile = b['mobile'] as String;
        _date = date;
        _time = time;
        _services = services;
        _loading = false;
      });
    } else {
      _showError(data['message'] as String);
    }
  }

  IconData _iconForService(String name) {
    switch (name) {
      case 'Skin Fade': return Icons.person;
      case 'Kids Haircut': return Icons.child_care;
      case 'Beard Grooming': return Icons.face;
      case 'Long Trim': return Icons.cut;
      case 'Haircut': return Icons.person;
      default: return Icons.cut;
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $msg')),
    );
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final fmtDate = "${_date!.year}-"
        "${_date!.month.toString().padLeft(2, '0')}-"
        "${_date!.day.toString().padLeft(2, '0')}";

    final fmtTime = _time!.format(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: Text(
          'Booking Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF003925)],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 16),
            // Header Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Color(0xFF00603F),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Booking ID',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Date & Time',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(widget.bookingId,
                              style: TextStyle(color: Colors.white)),
                          SizedBox(height: 8),
                          Text(fmtDate, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Services List + Subtotal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                decoration: BoxDecoration(
                  color: Color(0xFF00603F),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Services',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),

                    // Each service row
                    ..._services.map((svc) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(svc.icon, size: 32, color: Colors.white),
                          ),
                          SizedBox(width: 24),
                          Expanded(
                            child: Text(svc.name,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                          Text('RM ${svc.price.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    )),

                    Divider(color: Colors.white, thickness: 1),
                    SizedBox(height: 8),

                    // Subtotal row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text(
                          'RM ${_services.fold<double>(0, (sum, s) => sum + s.price).toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Spacer(),

            // View All Bookings button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BookingPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00603F),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  ),
                  child: Text('View All Bookings',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
