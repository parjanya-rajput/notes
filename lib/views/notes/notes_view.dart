import 'package:first_flutter/services/auth/auth_service.dart';
import 'package:first_flutter/services/crud/notes_service.dart';
import 'package:first_flutter/views/notes/note_list_view.dart';
import 'package:flutter/material.dart';

import '../../Utilities/dialogs/log_out_dialog.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final NotesService _notesService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes'),
          backgroundColor: Colors.blueAccent,
          actions: [
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }
              }
            }, itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Log Out')),
              ];
            })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(newNoteRoute);
          },
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
            future: _notesService.getOrCreateUser(email: userEmail),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return StreamBuilder(
                      stream: _notesService.allNote,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              final allNotes =
                                  snapshot.data as List<DatabaseNote>;
                              return NotesListView(notes: allNotes, onDeleteNote: (note) async {
                                await _notesService.deleteNote(id: note.id);
                              });
                            } else {
                              return const CircularProgressIndicator();
                            }
                          default:
                            return const CircularProgressIndicator();
                        }
                      });
                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
