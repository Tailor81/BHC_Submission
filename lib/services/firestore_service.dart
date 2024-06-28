import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUserProfile({
    required String uid,
    required String name,
    required String surname,
    required String omang,
    required DateTime dateOfBirth,
    required String residentialAddress,
    required String postalAddress,
    required List<String> plotNumbers,
    String? imageUrl, // Optional imageUrl parameter for profile picture
  }) async {
    try {
      await _db.collection('user_profile').doc(uid).set({
        'name': name,
        'surname': surname,
        'omang': omang,
        'dateOfBirth': dateOfBirth,
        'residentialAddress': residentialAddress,
        'postalAddress': postalAddress,
        'plotNumbers': plotNumbers,
        if (imageUrl != null) 'imageUrl': imageUrl, // Conditionally add imageUrl
      });
    } catch (e) {
      print('Error adding user profile: $e');
      // Handle error adding user profile
      rethrow; // Rethrow the exception to propagate it further if needed
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(String uid) async {
    try {
      return await _db.collection('user_profile').doc(uid).get();
    } catch (e) {
      print('Error fetching user profile: $e');
      // Handle error fetching user profile
      rethrow; // Rethrow the exception to propagate it further if needed
    }
  }
}
