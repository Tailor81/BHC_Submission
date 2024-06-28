import 'package:flutter/material.dart';

class PropertyListScreen extends StatelessWidget {
  final String type; // 'sale' or 'rent'

  const PropertyListScreen({required this.type});

  @override
  Widget build(BuildContext context) {
    // Replace with actual data fetching logic as per Firebase setup
    List<Map<String, dynamic>> properties = [
      {
        'image': 'assets/house1.jpg',
        'title': 'Beautiful House for Sale',
        'price': '500,000',
        'rooms': 3,
        'bathrooms': 2,
        'garage': true,
        'description':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      },
      // Add more properties as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            type == 'sale' ? 'Properties for Sale' : 'Properties for Rent'),
      ),
      body: ListView.builder(
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return _buildPropertyCard(context, properties[index]);
        },
      ),
    );
  }

  Widget _buildPropertyCard(
      BuildContext context, Map<String, dynamic> property) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.asset(
            property['image'],
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  property['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text('Price: \$${property['price']}'),
                const SizedBox(height: 5),
                Text('Rooms: ${property['rooms']}'),
                const SizedBox(height: 5),
                Text('Bathrooms: ${property['bathrooms']}'),
                const SizedBox(height: 5),
                Text('Garage: ${property['garage'] ? 'Yes' : 'No'}'),
                const SizedBox(height: 10),
                Text(
                  property['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to detailed property view
                      // Example: Navigator.pushNamed(context, '/property/details', arguments: property);
                    },
                    child: const Text('Show More'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
