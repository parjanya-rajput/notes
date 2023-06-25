import 'package:first_flutter/constants/routes.dart';
import 'package:first_flutter/services/auth/auth_service.dart';
import 'package:first_flutter/views/login_view.dart';
import 'package:first_flutter/views/notes_view.dart';
import 'package:first_flutter/views/register_view.dart';
import 'package:first_flutter/views/verify_email_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
        home: const HomePage(),
        routes: {
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const RegisterView(),
          verifyEmailRoute: (context) => const VerifyEmailPageView(),
          notesRoute: (context) => const NoteView(),
        }),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NoteView();
              } else {
                return const VerifyEmailPageView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}


