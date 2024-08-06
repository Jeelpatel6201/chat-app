import 'dart:io';

import 'package:chat_app/provider/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  File? _image;
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Email"),
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Email";
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Password"),
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Password";
                }
                return null;
              },
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3876FD),
                    foregroundColor: Colors.white),
                onPressed: () async {
                  try {
                     AuthProvider().signUp(_emailController.text,
                        _passwordController.text, _nameController.text, _image);
                  } catch (e) {
                    print("Create Account :- $e");
                  }
                },
                child: Text(
                  "Create Account",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Or"),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(),
                  ),
                );
              },
              child: Text(
                "",
                style: TextStyle(color: Color(0xFF3876FD)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
