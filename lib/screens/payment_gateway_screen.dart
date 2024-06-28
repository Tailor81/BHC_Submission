// payment_gateway_screen.dart
import 'package:flutter/material.dart';

class PaymentGatewayScreen extends StatefulWidget {
  const PaymentGatewayScreen({super.key});

  @override
  _PaymentGatewayScreenState createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  final _formKey = GlobalKey<FormState>();
  String _cardNumber = '';
  String _expirationDate = '';
  String _cvv = '';
  bool _loading = false; // new loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Gateway'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator() // loading animation
            : Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Card Number
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your card number';
                      }
                      return null;
                    },
                    onSaved: (value) => _cardNumber = value!,
                  ),

                  // Expiration Date
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Expiration Date',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your expiration date';
                      }
                      return null;
                    },
                    onSaved: (value) => _expirationDate = value!,
                  ),

                  // CVV
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your CVV';
                      }
                      return null;
                    },
                    onSaved: (value) => _cvv = value!,
                  ),

                  // Pay Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() {
                          _loading = true; // start loading animation
                        });
                        // simulate payment processing
                        Future.delayed(const Duration(seconds: 30), () {
                          // payment successful
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Payment successful')),
                          );
                          // navigate back to payment screen
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: const Text('Pay'),
                  ),
                ],
              ),
            ),
          ),
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