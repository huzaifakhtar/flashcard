// File: /lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save user data
  Future<void> saveUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid).set(data);
    } catch (e) {
      print(e.toString());
    }
  }

  // Fetch user data
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserData(String uid) async {
    try {
      return await _db.collection('users').doc(uid).get();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
