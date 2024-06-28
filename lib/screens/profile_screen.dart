import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController omangController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController residentialAddressController = TextEditingController();
  TextEditingController postalAddressController = TextEditingController();
  TextEditingController plotNumbersController = TextEditingController();

  File? _imageFile; // Variable to hold the selected image file
  String? _imageUrl; // Variable to hold the uploaded image URL

  @override
  void initState() {
    super.initState();
    // Load user profile data on screen initialization
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      // Fetch user profile data from Firestore
      var userProfile = await _firestoreService.getUserProfile(widget.user.uid);
      if (userProfile.exists) {
        setState(() {
          // Ensure userProfile.data() is of type Map<String, dynamic>
          Map<String, dynamic>? userData =
          userProfile.data() as Map<String, dynamic>?;

          // Populate form fields with existing profile data
          nameController.text = userData?['name'] ?? '';
          surnameController.text = userData?['surname'] ?? '';
          omangController.text = userData?['omang'] ?? '';
          dobController.text =
              userData?['dateOfBirth']?.toDate().toString() ?? '';
          residentialAddressController.text =
              userData?['residentialAddress'] ?? '';
          postalAddressController.text = userData?['postalAddress'] ?? '';
          plotNumbersController.text =
              (userData?['plotNumbers'] as List<dynamic>?)?.join(', ') ?? '';

          _imageUrl = userData?['imageUrl']; // Set imageUrl if available
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
      // Handle error loading profile data
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveUserProfile() async {
    if (_formKey.currentState!.validate()) {
      // Upload image if _imageFile is not null
      if (_imageFile != null) {
        _imageUrl = await _uploadImage();
      }

      await _firestoreService.addUserProfile(
        uid: widget.user.uid,
        name: nameController.text,
        surname: surnameController.text,
        omang: omangController.text,
        dateOfBirth: DateTime.parse(dobController.text),
        residentialAddress: residentialAddressController.text,
        postalAddress: postalAddressController.text,
        plotNumbers:
        plotNumbersController.text.split(',').map((e) => e.trim()).toList(),
        imageUrl: _imageUrl, // Assign the imageUrl to userProfile
      );

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<String> _uploadImage() async {
    try {
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('user_profile_images/${widget.user.uid}/profile_picture.jpg');

      await firebaseStorageRef.putFile(_imageFile!);
      return await firebaseStorageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : _imageUrl != null
                        ? NetworkImage(_imageUrl!)
                        : AssetImage('assets/default_profile.png'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                value!.isEmpty ? 'Enter your name' : null,
              ),
              TextFormField(
                controller: surnameController,
                decoration: InputDecoration(labelText: 'Surname'),
                validator: (value) =>
                value!.isEmpty ? 'Enter your surname' : null,
              ),
              TextFormField(
                controller: omangController,
                decoration: InputDecoration(labelText: 'Omang'),
                validator: (value) => value!.isEmpty ? 'Enter your Omang' : null,
              ),
              TextFormField(
                controller: dobController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Enter your date of birth' : null,
              ),
              TextFormField(
                controller: residentialAddressController,
                decoration: InputDecoration(labelText: 'Residential Address'),
                validator: (value) =>
                value!.isEmpty ? 'Enter your residential address' : null,
              ),
              TextFormField(
                controller: postalAddressController,
                decoration: InputDecoration(labelText: 'Postal Address'),
                validator: (value) =>
                value!.isEmpty ? 'Enter your postal address' : null,
              ),
              TextFormField(
                controller: plotNumbersController,
                decoration: InputDecoration(
                    labelText: 'Plot Numbers (comma separated)'),
                validator: (value) =>
                value!.isEmpty ? 'Enter your plot numbers' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUserProfile,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.orange,
                ),
                child: Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
