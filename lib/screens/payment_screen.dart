import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double _owingBalance = 1000.0; // initial owing balance
  bool _pendingPayment = true; // initial pending payment status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Owing Balance
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Owing Balance:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '\$${_owingBalance.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // View Statements
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'View Statements:',
                      style: TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // navigate to statement screen
                        Navigator.pushNamed(context, '/statements');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: Colors.orange, // Black text color
                      ),
                      child: Text('TPS & Past Transactions'),
                    ),
                  ],
                ),
              ),
            ),

            // Make Payment
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Make Payment:',
                      style: TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // navigate to payment gateway
                        Navigator.pushNamed(context, '/payment_gateway');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: Colors.orange, // Black text color
                      ),
                      child: Text('Pay \$500'),
                    ),
                  ],
                ),
              ),
            ),

            // Pending Payment
            _pendingPayment
                ? Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pending Payment:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '\$500',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
                : Container(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange,
        child: Container(height: 50),
      ),
      backgroundColor: Colors.white,
    );
  }
}
