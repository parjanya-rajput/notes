import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';

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
          const Text(
              "We've sent the Email for verification of your account, kindly click the link in the mail."),
          const Text("If you haven't received the Email click the below button."),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text("Send Email Verification")),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                      (route) => false,
                );
              },
              child: const Text('Restart'))
        ],
      ),
    );
  }
}
