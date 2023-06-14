import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifyEmailPageView extends StatefulWidget {
  const VerifyEmailPageView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPageView> createState() => _VerifyEmailPageViewState();
}

class _VerifyEmailPageViewState extends State<VerifyEmailPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          const Text('Please Verify your Email First'),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text("Send Email Verification"))
        ],
      ),
    );
  }
}