import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedCity;
  String? selectedType;
  RangeValues priceRange = RangeValues(0, 1000000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Properties'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDropdown('City', ['City1', 'City2', 'City3'], (value) {
              setState(() {
                selectedCity = value;
              });
            }),
            const SizedBox(height: 10),
            _buildDropdown('Type', ['rent', 'buy'], (value) {
              setState(() {
                selectedType = value;
              });
            }),
            const SizedBox(height: 10),
            _buildPriceRangeSlider(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchProperties,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text('Search'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildPropertyList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      items: options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price Range'),
        RangeSlider(
          values: priceRange,
          min: 0,
          max: 1000000,
          divisions: 100,
          labels: RangeLabels(
            '\$${priceRange.start.round()}',
            '\$${priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              priceRange = values;
            });
          },
        ),
      ],
    );
  }

  void _searchProperties() {
    setState(() {});
  }

  Widget _buildPropertyList() {
    Query query = FirebaseFirestore.instance.collection('property');

    if (selectedCity != null && selectedCity!.isNotEmpty) {
      query = query.where('location', isEqualTo: selectedCity);
    }

    if (selectedType != null && selectedType!.isNotEmpty) {
      query = query.where('type', isEqualTo: selectedType);
    }

    query = query
        .where('price', isGreaterThanOrEqualTo: priceRange.start.round())
        .where('price', isLessThanOrEqualTo: priceRange.end.round());

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var properties = snapshot.data!.docs;

        if (properties.isEmpty) {
          return const Center(child: Text('No properties found'));
        }

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
    );
  }
}
