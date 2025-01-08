import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/Users.dart';
import '../models/user_singleton.dart';

class LoginRepository{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("Invalid Credentials");
      } else if (e.code == 'wrong-password') {
        throw Exception("Wrong password provided for that user.");
      } else {
        throw Exception(e.message ?? "Unknown error occurred");
      }
    }
  }
  User? getCurrentUser() {
    return _auth.currentUser;
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }
  Future<bool> checkUserRole(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();


        if (data != null && data['role'].toString().toLowerCase() == 'retailer') {
          Users userModel = Users.fromMap(data);
          userModel.uid = uid;
          UserSingleton().setUser(userModel);
          return true;
        }
      }
      return false;
    } catch (e) {
      throw Exception("Error checking user role: $e");
    }
  }
}