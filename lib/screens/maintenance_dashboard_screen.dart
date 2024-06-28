import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'maintenance_screen.dart';

class MaintenanceDashboardScreen extends StatefulWidget {
  const MaintenanceDashboardScreen({Key? key}) : super(key: key);

  @override
  _MaintenanceDashboardScreenState createState() =>
      _MaintenanceDashboardScreenState();
}

class _MaintenanceDashboardScreenState
    extends State<MaintenanceDashboardScreen> {
  late Future<List<Map<String, dynamic>>> _maintenanceRequests;

  @override
  void initState() {
    super.initState();
    _maintenanceRequests = _fetchMaintenanceRequests();
    _addSampleDataIfNeeded(); // Add sample data for attended faults if needed
  }

  Future<List<Map<String, dynamic>>> _fetchMaintenanceRequests() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('maintenance_logs')
        .where('user_id', isEqualTo: userId)
        .get();
    return querySnapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  void _showFaultReportScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MaintenanceScreen(),
      ),
    ).then((value) {
      if (value == true) {
        setState(() {
          _maintenanceRequests = _fetchMaintenanceRequests();
        });
      }
    });
  }

  void _callCustomerContactCenter() async {
    const phoneNumber = 'tel:3159902';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _addSampleDataIfNeeded() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot existingData = await FirebaseFirestore.instance
        .collection('maintenance_logs')
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'Attended')
        .get();

    int existingCount = existingData.docs.length;
    int maxEntries = 5;

    if (existingCount < maxEntries) {
      List<Map<String, dynamic>> sampleData = [
        {
          'user_id': userId,
          'incident': 'No power',
          'price': 100.0,
          'timestamp': Timestamp.now(),
          'reference_number': '123456',
          'status': 'Attended',
        },
        {
          'user_id': userId,
          'incident': 'Electric shock',
          'price': 150.0,
          'timestamp': Timestamp.now(),
          'reference_number': '654321',
          'status': 'Attended',
        },
      ];

      for (var i = 0; i < maxEntries - existingCount; i++) {
        await FirebaseFirestore.instance.collection('maintenance_logs').add(
            sampleData[i % sampleData.length]);
      }
    }

    setState(() {
      _maintenanceRequests = _fetchMaintenanceRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _maintenanceRequests,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error fetching maintenance requests.');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No maintenance requests found.');
                } else {
                  var pendingRequests = snapshot.data!
                      .where((request) => request['status'] == 'Pending')
                      .toList();
                  var attendedRequests = snapshot.data!
                      .where((request) => request['status'] == 'Attended')
                      .toList();

                  return Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Pending Faults',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Card(
                            color: Colors.orange.shade50,
                            child: ListView.builder(
                              itemCount: pendingRequests.length,
                              itemBuilder: (context, index) {
                                var request = pendingRequests[index];
                                return ListTile(
                                  title: Text(request['incident']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text('Price: ${request['price']} BWP'),
                                      if (request['image_url'] != null)
                                        Image.network(request['image_url']),
                                      Text(
                                          'Reference: ${request['reference_number']}'),
                                      Text(
                                          'Logged on: ${request['timestamp'].toDate()}'),
                                    ],
                                  ),
                                  onTap: () {
                                    // Handle the tap to show detailed view of the request
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Attended Faults',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Card(
                            color: Colors.orange.shade50,
                            child: ListView.builder(
                              itemCount: attendedRequests.length,
                              itemBuilder: (context, index) {
                                var request = attendedRequests[index];
                                return ListTile(
                                  title: Text(request['incident']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text('Price: ${request['price']} BWP'),
                                      if (request['image_url'] != null)
                                        Image.network(request['image_url']),
                                      Text(
                                          'Reference: ${request['reference_number']}'),
                                      Text(
                                          'Attended on: ${request['timestamp'].toDate()}'),
                                    ],
                                  ),
                                  onTap: () {
                                    // Handle the tap to show detailed view of the request
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _showFaultReportScreen,
                child: const Text('Report Fault'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.orange,
                ),
              ),
              ElevatedButton(
                onPressed: _callCustomerContactCenter,
                child: const Text('Call Customer Center'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
