import 'package:flutter/material.dart';
import 'date_time.dart'; // Import DateTimePage
import 'service.dart';   // Import the Service class

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final List<Service> services = [
    Service(name: 'Skin Fade', price: 30.00, icon: Icons.person),
    Service(name: 'Kids Haircut', price: 20.00, icon: Icons.child_care),
    Service(name: 'Beard Grooming', price: 10.00, icon: Icons.face),
    Service(name: 'Long Trim', price: 40.00, icon: Icons.cut),
    Service(name: 'Haircut', price: 35.00, icon: Icons.person),
  ];

  List<bool> selectedServices = [false, false, false, false, false];
  bool isSelected = false;

  void updateSelection(int index) {
    setState(() {
      selectedServices[index] = !selectedServices[index];
      isSelected = selectedServices.contains(true); // Enable 'Next' if at least one service is selected
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Select Service', style: TextStyle(fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () => updateSelection(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedServices[index] ? Colors.green : Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(services[index].icon, color: Colors.white),
                            SizedBox(width: 16),
                            Text(
                              services[index].name,
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Spacer(),
                            Text(
                              'RM ${services[index].price}',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Text(
              'Please select at least 1 service',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSelected
                  ? () {
                // Convert the selected services into a List<Service>
                List<Service> selectedServicesData = [];
                for (int i = 0; i < selectedServices.length; i++) {
                  if (selectedServices[i]) {
                    selectedServicesData.add(services[i]);
                  }
                }

                // Navigate to DateTimePage with selected services
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DateTimePage(
                      services: selectedServicesData,  // Pass selected services
                    ),
                  ),
                );
              }
                  : null,
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
