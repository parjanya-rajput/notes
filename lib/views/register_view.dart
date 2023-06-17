import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_flutter/constants/routes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

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
        title: const Text('Register'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
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
                      try{
                        final email = _email.text;
                        final password = _password.text;
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                            email: email, password: password);
                        devtools.log(userCredential.toString());
                      } on FirebaseAuthException catch (e){
                        if(e.code == 'weak-password'){
                          devtools.log('Weak Password');
                        } else if(e.code == 'email-already-in-use'){
                          devtools.log('User already exists');
                        } else if(e.code == 'invalid-email'){
                          devtools.log('Invalid Email Format');
                        }
                      }
                    },
                    child: const Text('Register'),
                  ),
                  TextButton(onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
                  },
                      child: const Text('Already Registered! Login Here'))
                ],
              );
            default:
              return const Text('Loading');
          }
        },
      ),
    );
  }
}