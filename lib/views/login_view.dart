// ignore_for_file: use_build_context_synchronously
import 'package:first_flutter/constants/routes.dart';
import 'package:first_flutter/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../Utilities/show_error_dialog_file.dart';
import '../services/auth/auth_exceptions.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('LogIn'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter your email",
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                hintText: "Enter your password",
              ),
            ),
            TextButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              onPressed: () async {
                try {
                  final email = _email.text;
                  final password = _password.text;
                  await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );
                  final user = AuthService
                      .firebase()
                      .currentUser;
                  if (user?.isEmailVerified ?? false) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      notesRoute,
                          (route) => false,
                    );
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      verifyEmailRoute,
                          (route) => false,
                    );
                  }
                } on UserNotFoundAuthException {
                  await showErrorDialog(
                    context,
                    'User Not Found',
                  );
                } on WrongPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Wrong Credentials',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Authentication Error',
                  );
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, registerRoute, (route) => false);
                },
                child: const Text("Not Registered yet? Register Here!"))
          ],
        )
    );
  }
}
