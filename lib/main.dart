import 'package:first_flutter/constants/routes.dart';
import 'package:first_flutter/services/auth/auth_service.dart';
import 'package:first_flutter/services/auth/bloc/auth_bloc.dart';
import 'package:first_flutter/services/auth/bloc/auth_event.dart';
import 'package:first_flutter/services/auth/bloc/auth_state.dart';
import 'package:first_flutter/services/auth/firebase_auth_provider.dart';
import 'package:first_flutter/views/login_view.dart';
import 'package:first_flutter/views/notes/create_update_note_view.dart';
import 'package:first_flutter/views/notes/notes_view.dart';
import 'package:first_flutter/views/register_view.dart';
import 'package:first_flutter/views/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
        home: BlocProvider(
          create: (context) => AuthBloc(FireBaseAuthProvider()),
          child: const HomePage(),
        ),
        routes: {
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const RegisterView(),
          verifyEmailRoute: (context) => const VerifyEmailPageView(),
          notesRoute: (context) => const NoteView(),
          createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        }),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(builder: (context,state) {
      if(state is AuthStateLoggedIn){
        return const NoteView();
      } else if (state is AuthStateNeedsVerification){
        return const VerifyEmailPageView();
      } else if(state is AuthStateLoggedOut){
        return const LoginView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    },);

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
//Bloc trial counter
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;
//
//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Testing Bloc'),
//             backgroundColor: Colors.blueAccent,
//           ),
//           body: BlocConsumer<CounterBloc, CounterState>(
//               builder: (context, state) {
//             final invalidValue =
//                 (state is InvalidCounterState) ? state.invalidValue : '';
//             return Column(
//               children: [
//                 Text('Current Value => ${state.value}'),
//                 Visibility(
//                   visible: state is InvalidCounterState,
//                   child: Text('Invalid Input: $invalidValue'),
//                 ),
//                 TextField(
//                   controller: _controller,
//                   decoration: const InputDecoration(
//                     hintText: "Enter your text here",
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 Row(
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         context.read<CounterBloc>().add(
//                               DecrementEvent(_controller.text),
//                             );
//                       },
//                       child: const Text('-'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         context.read<CounterBloc>().add(
//                               IncrementEvent(_controller.text),
//                             );
//                       },
//                       child: const Text('+'),
//                     )
//                   ],
//                 )
//               ],
//             );
//           }, listener: (context, state) {
//             _controller.clear();
//           })),
//     );
//   }
// }
//
// @immutable
// abstract class CounterState {
//   final int value;
//
//   const CounterState(this.value);
// }
//
// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }
//
// class InvalidCounterState extends CounterState {
//   final String invalidValue;
//
//   const InvalidCounterState({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }
//
// @immutable
// abstract class CounterEvent {
//   final String value;
//
//   const CounterEvent(this.value);
// }
//
// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(String value) : super(value);
// }
//
// class DecrementEvent extends CounterEvent {
//   const DecrementEvent(String value) : super(value);
// }
//
// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<IncrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(
//           InvalidCounterState(
//             invalidValue: event.value,
//             previousValue: state.value,
//           ),
//         );
//       } else {
//         emit(
//           CounterStateValid(state.value + integer),
//         );
//       }
//     });
//     on<DecrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(
//           InvalidCounterState(
//             invalidValue: event.value,
//             previousValue: state.value,
//           ),
//         );
//       } else {
//         emit(
//           CounterStateValid(state.value - integer),
//         );
//       }
//     });
//   }
// }
