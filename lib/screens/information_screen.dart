import 'package:flutter/material.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  Future<List<Map<String, String>>> fetchInformation() async {
    // Simulate fetching data from an API or service
    await Future.delayed(const Duration(seconds: 2));
    return [
      {
        'title': 'New Management Announcement',
        'description': 'BHC announces new CEO as of June 2024. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet.',
        'image': 'assets/1.jpg', // Placeholder image path
        'content': 'Full article content for New Management Announcement...'
      },
      {
        'title': 'Latest Housing Deals',
        'description': 'Exclusive 20% off on all new apartment bookings in Gaborone. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        'image': 'assets/1.jpg', // Placeholder image path
        'content': 'Full article content for Latest Housing Deals...'
      },
      {
        'title': 'Housing Trends 2024',
        'description': 'An insight into the housing market trends for 2024. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        'image': 'assets/1.jpg', // Placeholder image path
        'content': 'Full article content for Housing Trends 2024...'
      },
      {
        'title': 'BHC News',
        'description': 'BHC wins the best housing corporation award. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        'image': 'assets/1.jpg', // Placeholder image path
        'content': 'Full article content for BHC News...'
      },
    ];
  }

  void _navigateToDetail(BuildContext context, Map<String, String> info) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InformationDetailScreen(info: info),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange, // Set orange color for app bar
        elevation: 0, // Optional: Remove shadow
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: fetchInformation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load information.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No information available.'));
          } else {
            final informationList = snapshot.data!;
            return ListView.builder(
              itemCount: informationList.length,
              itemBuilder: (context, index) {
                final info = informationList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: InkWell(
                    onTap: () => _navigateToDetail(context, info),
                    child: Column(
                      children: [
                        Image.asset(
                          info['image']!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                info['title']!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                info['description']!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: () => _navigateToDetail(context, info),
                                child: const Text('Read More'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      backgroundColor: Colors.white, // Set white background
    );
  }
}

class InformationDetailScreen extends StatelessWidget {
  final Map<String, String> info;

  const InformationDetailScreen({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange, // Set orange color for app bar
        elevation: 0, // Optional: Remove shadow
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              info['image']!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              info['title']!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              info['content']!,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white, // Set white background
    );
  }
}
