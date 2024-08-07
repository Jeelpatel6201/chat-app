import 'package:chat_app/screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthProvider with ChangeNotifier {
   FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;
  Future<void> signIn({email,  password, context}) async {
    print("email:-$email");
    print("password:-$password");
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Fluttertoast.showToast(msg: "Login Success");
      notifyListeners();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } catch (e) {
      print("logIn :- $e");
    }
  }

  // Future<void> signUp(
  //     String email, String password, String name, String imageUrl) async {
  //   UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email, password: password);
  //   await _fireStore.collection('users').doc(userCredential.user!.uid).set({
  //     'uid': userCredential.user!.uid,
  //     "name": name,
  //     "email": email,
  //     "imageUrl": imageUrl,
  //   });
  //   notifyListeners();
  // }
  // Future<void> signOut() async {
  //   await _auth.signOut();
  //   notifyListeners();
  // }
}
