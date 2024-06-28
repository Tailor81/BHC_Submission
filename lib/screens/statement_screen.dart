import 'package:flutter/material.dart';

class StatementScreen extends StatelessWidget {
  const StatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statements'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // TPS Statement
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'TPS Statement',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Date: 2022-01-01',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Amount: \$1000.00',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            // Past Transactions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Past Transactions',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text('2022-01-05: Payment of \$500.00'),
                    ),
                    ListTile(
                      title: Text('2022-01-10: Payment of \$200.00'),
                    ),
                    ListTile(
                      title: Text('2022-01-15: Payment of \$300.00'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Container(height: 50),
      ),
      backgroundColor: Colors.white,
    );
  }
}
