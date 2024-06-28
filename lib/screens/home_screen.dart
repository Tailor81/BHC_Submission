
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> _confirmLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: Text('Logout'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _fetchUserProfile(String uid) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('user_profile').doc(uid).get();
    return doc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: _fetchUserProfile(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Welcome, User!');
            } else if (snapshot.hasError) {
              return const Text('Welcome, User!');
            } else {
              final userName = snapshot.data?['name'] ?? 'User';
              return Text('Welcome, $userName!');
            }
          },
        ),
        backgroundColor: Colors.orange,
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/user.jpg'), // Placeholder image
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Image.asset(
                'assets/images/bhc_logo.png',
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Maintenance'),
              onTap: () {
                Navigator.pushNamed(context, '/maintenance');
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_work),
              title: const Text('Applications'),
              onTap: () {
                Navigator.pushNamed(context, '/application');
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payments'),
              onTap: () {
                Navigator.pushNamed(context, '/payment');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Information'),
              onTap: () {
                Navigator.pushNamed(context, '/information');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: user!)),
                );
              },
            ),
            Divider(), // Add a divider before logout button
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _confirmLogout(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                'Dashboard Overview',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.orange.shade50,
                child: ListTile(
                  leading: Icon(Icons.report_problem, color: Colors.orange),
                  title: const Text('Reported Faults'),
                  subtitle: const Text('You have 2 unresolved faults'),
                  trailing: Icon(Icons.arrow_forward, color: Colors.orange),
                  onTap: () {
                    // Navigate to faults details screen
                  },
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.orange.shade50,
                child: ListTile(
                  leading: Icon(Icons.home, color: Colors.orange),
                  title: const Text('Latest Property Listings'),
                  subtitle: const Text('5 new properties available'),
                  trailing: Icon(Icons.arrow_forward, color: Colors.orange),
                  onTap: () {
                    // Navigate to property listings screen
                  },
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.orange.shade50,
                child: ListTile(
                  leading: Icon(Icons.monetization_on, color: Colors.orange),
                  title: const Text('Rent Payment Due'),
                  subtitle: const Text('Your rent is due in 3 days'),
                  trailing: Icon(Icons.arrow_forward, color: Colors.orange),
                  onTap: () {
                    // Navigate to payment details screen
                  },
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.orange.shade50,
                child: ListTile(
                  leading: Icon(Icons.new_releases, color: Colors.orange),
                  title: const Text('Recent News'),
                  subtitle: const Text('Check out the latest updates'),
                  trailing: Icon(Icons.arrow_forward, color: Colors.orange),
                  onTap: () {
                    // Navigate to news details screen
                  },
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.orange.shade50,
                child: ListTile(
                  leading: Icon(Icons.notifications, color: Colors.orange),
                  title: const Text('Notifications'),
                  subtitle: const Text('You have 3 new notifications'),
                  trailing: Icon(Icons.arrow_forward, color: Colors.orange),
                  onTap: () {
                    // Navigate to notifications screen
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange, // Solid color for the bottom bar
        elevation: 0, // No shadow
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home_work, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/application');
              },
            ),
            IconButton(
              icon: Icon(Icons.payment, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/payment');
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: user!)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


