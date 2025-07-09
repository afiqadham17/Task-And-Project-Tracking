// booking_details.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  bool _loading = true;
  String _mobile = '';
  DateTime? _date;
  TimeOfDay? _time;
  List<Service> _services = [];

  @override
  void initState() {
    super.initState();
    _fetchBooking();
  }

  Future<void> _fetchBooking() async {
    final url = Uri.parse(
      'http://10.41.113.6/barberApp/retrieve_booking.php'
          '?booking_id=${widget.bookingId}',
    );
    try {
      final res = await http.get(url);
      final data = jsonDecode(res.body);

      if (data['status'] == 'success') {
        final b = data['booking'] as Map<String, dynamic>;
        final svcList = data['services'] as List<dynamic>;

        // parse date
        final date = DateTime.parse(b['booking_date'] as String);
        // parse time
        final parts = (b['booking_time'] as String).split(':');
        final time = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
        // parse services
        final services = svcList.map((s) {
          final name  = s['service_name'] as String;
          final price = double.parse(s['price'].toString());
          return Service(
            name: name,
            price: price,
            icon: _iconForService(name),
          );
        }).toList();

        setState(() {
          _mobile   = b['mobile'] as String;
          _date     = date;
          _time     = time;
          _services = services;
          _loading  = false;
        });
      } else {
        _showError(data['message'] as String);
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  IconData _iconForService(String name) {
    switch (name) {
      case 'Skin Fade':      return Icons.person;
      case 'Kids Haircut':   return Icons.child_care;
      case 'Beard Grooming': return Icons.face;
      case 'Long Trim':      return Icons.cut;
      case 'Haircut':        return Icons.person;
      default:               return Icons.cut;
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
        "${_date!.month.toString().padLeft(2,'0')}-"
        "${_date!.day.toString().padLeft(2,'0')}";

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
                              border:
                              Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(svc.icon,
                                size: 32, color: Colors.white),
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
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BookingPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00603F),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  child: Text('View All Bookings',
                      style: TextStyle(
                          fontSize: 18, color: Colors.white)),
                ),
              ),
            ),

            // Cancel Booking button
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB75A36),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  child: Text('Cancel Booking',
                      style: TextStyle(
                          fontSize: 18, color: Colors.white)),
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
