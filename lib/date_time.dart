// date_time.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'booking_details.dart';
import 'service.dart';

class DateTimePage extends StatefulWidget {
  final List<Service> services;

  const DateTimePage({super.key, required this.services});

  @override
  _DateTimePageState createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool _isSubmitting = false;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
    }
  }

  String get formattedDate {
    final y = selectedDate.year;
    final m = selectedDate.month.toString().padLeft(2, '0');
    final d = selectedDate.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String get formattedTime {
    return selectedTime.format(context);
  }

  Future<void> _confirmBooking() async {
    setState(() => _isSubmitting = true);

    // 3.1 Get mobile
    final prefs = await SharedPreferences.getInstance();
    final mobile = prefs.getString('mobile') ?? '';
    if (mobile.isEmpty) {
      _showError('No mobile number saved.');
      setState(() => _isSubmitting = false);
      return;
    }

    // 3.2 Build services JSON
    final servicesJson = jsonEncode(widget.services.map((s) => {
      'name': s.name,
      'price': s.price,
    }).toList());

    // 3.3 POST to PHP (use 10.0.2.2 for USB-connected device)
    final url = Uri.parse('http://10.41.113.6/barberApp/insert_booking.php');
    debugPrint('Posting to $url');
    debugPrint('Body => mobile=$mobile, date=$formattedDate, time=$formattedTime, services=$servicesJson');

    try {
      final response = await http.post(url, body: {
        'mobile':   mobile,
        'date':     formattedDate,
        'time':     formattedTime,
        'services': servicesJson,
      });

      debugPrint('Response(${response.statusCode}): ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final bookingId = data['booking_id'].toString();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookingDetailsPage(bookingId: bookingId)),
          );
          return;
        } else {
          _showError('Server error: ${data['message']}');
        }
      } else {
        _showError('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Exception: $e');
      debugPrint('Exception caught: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $msg')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Select Date & Time', style: TextStyle(fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date picker
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Date', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.white),
                        SizedBox(width: 16),
                        Text(formattedDate, style: TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Time picker
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Time', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white),
                        SizedBox(width: 16),
                        Text(formattedTime, style: TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _isSubmitting
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : Text('Confirm Booking (Now)', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
