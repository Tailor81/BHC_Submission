import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApplicationScreen extends StatelessWidget {
  const ApplicationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange, // Set orange color for app bar
        elevation: 0, // Optional: Remove shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Property Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _buildPropertyCard(
                      context,
                      'Latest Property for Sale',
                      'View the latest property for sale',
                      'buy',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _buildPropertyCard(
                      context,
                      'Latest Property for Rent',
                      'View the latest property for rent',
                      'rent',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildActionButton(
              context,
              'Search Properties',
              '/search',
              Colors.orange,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white, // Set white background
    );
  }

  Widget _buildPropertyCard(
      BuildContext context, String title, String description, String type) {
    return Card(
      color: Colors.orange.shade50, // Match the card color to HomeScreen
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
              context, type == 'buy' ? '/property/sale' : '/property/rent');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('property')
                      .where('type', isEqualTo: type)
                      .orderBy('price')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No properties found'),
                      );
                    }

                    var properties = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        var property = properties[index].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(property['description']),
                          subtitle: Text(
                            'Price: ${property['price']} USD\nLocation: ${property['location']}',
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/property/details',
                              arguments: property,
                            );
                          },
                        );
                      },
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

  Widget _buildActionButton(
      BuildContext context, String label, String route, Color color) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(vertical: 20),
        textStyle: const TextStyle(fontSize: 16, color: Colors.black),
        side: BorderSide(color: color),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
