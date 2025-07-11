import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'booking_details.dart';
import 'service.dart';

class DateTimePage extends StatefulWidget {
  final List<Service> services;

  const DateTimePage({Key? key, required this.services}) : super(key: key);

  @override
  _DateTimePageState createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isSubmitting = false;

  // Function to open the date picker
  Future<void> _selectDate(BuildContext ctx) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // Function to open the time picker
  Future<void> _selectTime(BuildContext ctx) async {
    final picked = await showTimePicker(
      context: ctx,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  String get _formattedDate {
    final y = _selectedDate.year;
    final m = _selectedDate.month.toString().padLeft(2, '0');
    final d = _selectedDate.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String get _formattedTime => _selectedTime.format(context);

  // Function to confirm booking
  Future<void> _confirmBooking() async {
    // Retrieve mobile number from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final mobile = prefs.getString('mobile') ?? ''; // Default to empty string if null
    debugPrint('⚙️ Stored mobile = $mobile'); // Debugging line

    // If mobile is empty, show an error
    if (mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No mobile found. Please log in first.')),
      );
      return;
    }

    // Prepare the services data
    final servicesJson = jsonEncode(widget.services.map((s) {
      return {'name': s.name, 'price': s.price};
    }).toList());

    debugPrint('⚙️ Booking info => mobile=$mobile, date=$_formattedDate, time=$_formattedTime, services=$servicesJson');

    setState(() => _isSubmitting = true);

    // Simulate a booking process (without PHP)
    await Future.delayed(const Duration(seconds: 2)); // Simulate a delay

    // Simulating successful booking response
    final data = {
      'status': 'success',
      'booking_id': '12345',  // Simulate a booking ID returned from the server
    };

    debugPrint('✨ Simulated response: $data');

    if (data['status'] == 'success' && data['booking_id'] != null) {
      // Pass the booking ID to the BookingDetailsPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingDetailsPage(
            bookingId: data['booking_id'].toString(), // Pass the booking ID
          ),
        ),
      );
    } else {
      final msg = data['message'] as String? ?? 'Booking failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Select Date & Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker
            GestureDetector(
              onTap: () => _selectDate(ctx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Date', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(_formattedDate,
                            style: const TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Time Picker
            GestureDetector(
              onTap: () => _selectTime(ctx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Time', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(_formattedTime,
                            style: const TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(), // Spacer to push the button down

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text('Confirm Booking (Now)', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
