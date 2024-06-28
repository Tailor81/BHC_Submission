import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'application_form.dart'; // Ensure to import the application form screen

class PropertyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> property;

  const PropertyDetailScreen({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = property['title'] ?? 'No title';
    final String description = property['description'] ?? 'No description available.';
    final String location = property['location'] ?? 'No location';
    final int price = property['price'] ?? 0;
    final int rooms = property['rooms'] ?? 0;
    final int bathrooms = property['bathrooms'] ?? 0;
    final int garage = property['garage'] ?? 0;
    final List<dynamic> imageUrls = property['imageUrls'] ?? [];
    final bool isAvailable = property['isAvailable'] ?? true;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            imageUrls.isNotEmpty
                ? Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(imageUrls[index]),
                  );
                },
              ),
            )
                : Container(
              height: 200,
              color: Colors.grey,
              child: const Center(
                child: Text('No Image Available'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Price: \$${price.toString()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Location: $location',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rooms: $rooms',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Bathrooms: $bathrooms',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Garage: ${garage > 0 ? 'Yes' : 'No'}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Description:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status:',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  isAvailable ? 'Available' : 'Unavailable',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isAvailable ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isAvailable
                ? ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApplicationFormScreen(property: property),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Apply Now',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
                : ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text('Unavailable'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
