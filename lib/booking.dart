import 'package:flutter/material.dart';
import 'home_page.dart';  // ensure HomePage is available

/// Booking List Page
class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedFilter = 'All(2)';

  final List<Map<String, dynamic>> bookings = [
    {
      'date': 'Today,11.04AM',
      'status': 'Cancelled',
      'statusColor': Color(0xFFB75A36),
      'services': 'Haircut, Beard Grooming',
      'total': 'RM 45.00',
    },
    {
      'date': '4/6/25,11.04AM',
      'status': 'Completed',
      'statusColor': Color(0xFF00603F),
      'services': 'Haircut, Beard Grooming',
      'total': 'RM 45.00',
    },
  ];

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
          'Booking',
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
              // Filter Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: ['All(2)', 'Completed', 'Cancelled'].map((filter) {
                    return Expanded(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00603F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            filter,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              // Booking Cards
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final b = bookings[index];
                    if (selectedFilter != 'All(2)' && b['status'] != selectedFilter) {
                      return const SizedBox.shrink();
                    }
                    final icon = b['status'] == 'Completed'
                        ? Icons.check_circle
                        : Icons.cancel;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF00603F),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Column(
                          children: [
                            // Top row: date & status with icon
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      b['date'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: b['statusColor'],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(icon,
                                            size: 16, color: Colors.white),
                                        const SizedBox(height: 4),
                                        Text(
                                          b['status'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                                color: Colors.white, thickness: 1),
                            // Services & Total
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                  BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: const [
                                          Text('Services',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                  FontWeight.bold)),
                                          SizedBox(height: 8),
                                          Text('Total Amount',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Text(b['services'],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16)),
                                          const SizedBox(height: 8),
                                          Text(b['total'],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16)),
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
