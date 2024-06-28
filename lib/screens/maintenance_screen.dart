import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:math';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  _MaintenanceScreenState createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  int? _selectedIncident;
  bool _isSubmitting = false;
  String? _responseMessage;
  File? _selectedImage;

  final List<Map<String, dynamic>> _incidents = [
    {'type': 'Electricity tripping', 'price': 100.0},
    {'type': 'No power', 'price': 120.0},
    {'type': 'Electric shock', 'price': 150.0},
    {'type': 'Burnt socket', 'price': 80.0},
    {'type': 'Broken socket', 'price': 90.0},
    {'type': 'Loose socket', 'price': 70.0},
    {'type': 'Faulty cooker control', 'price': 200.0},
    {'type': 'Torn/Loose Sprague tubing', 'price': 110.0},
    {'type': 'Flickering florescent tube', 'price': 60.0},
    {'type': 'Broken lamp shade', 'price': 50.0},
    {'type': 'Loose light fitting', 'price': 75.0},
    {'type': 'Security light fitting not working', 'price': 85.0},
    {'type': 'Bulb stub stuck in holder', 'price': 40.0},
    {'type': 'Burnt/Broken lamp holder', 'price': 55.0},
    {'type': 'Staircase lights faulty', 'price': 95.0},
    {'type': 'Leakage', 'price': 130.0},
    {'type': 'Water too hot', 'price': 140.0},
    {'type': 'Not heating', 'price': 125.0},
    {'type': 'Switch not working', 'price': 65.0},
    {'type': 'Tripping electricity', 'price': 115.0},
  ];

  Future<void> _submitReport() async {
    if (_selectedIncident == null) {
      setState(() {
        _responseMessage = 'Please select an incident before submitting.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String incident = _incidents[_selectedIncident!]['type'];
      double price = _incidents[_selectedIncident!]['price'];
      String referenceNumber = _generateReferenceNumber();

      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadImage(_selectedImage!);
      }

      await FirebaseFirestore.instance.collection('maintenance_logs').add({
        'user_id': userId,
        'incident': incident,
        'price': price,
        'timestamp': FieldValue.serverTimestamp(),
        'reference_number': referenceNumber,
        'image_url': imageUrl,
        'status': 'Pending',
      });

      _showSuccessDialog(referenceNumber);

    } catch (error) {
      setState(() {
        _responseMessage = 'Error submitting report: $error';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    String fileName = 'fault_${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageReference =
    FirebaseStorage.instance.ref().child('fault_images/$fileName');
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => null);
    return await storageReference.getDownloadURL();
  }

  String _generateReferenceNumber() {
    var rng = Random();
    return rng.nextInt(900000).toString().padLeft(6, '0');
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  void _showSuccessDialog(String referenceNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(
              'Your case has been logged with BHC. Your reference number is $referenceNumber. You will be assisted within 3 days.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

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
          children: [
            const Text(
              'Please select the type of incident you want to report:',
              style: TextStyle(fontSize: 16),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _incidents.length,
                itemBuilder: (context, index) {
                  return RadioListTile<int>(
                    title: Text('${_incidents[index]['type']} (${_incidents[index]['price']} BWP)'),
                    value: index,
                    groupValue: _selectedIncident,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedIncident = value;
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Attach Image'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.orange, // Black text color
              ),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Take Image'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.orange, // Black text color
              ),
            ),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 200,
              ),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReport,
              child: _isSubmitting
                  ? CircularProgressIndicator(
                color: Colors.white,
              )
                  : Text('Report Fault'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.orange, // Black text color
              ),
            ),
            if (_responseMessage != null) ...[
              const SizedBox(height: 20),
              Text(
                _responseMessage!,
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
            ]
          ],
        ),
      ),
      backgroundColor: Colors.white, // Set white background
    );
  }
}
