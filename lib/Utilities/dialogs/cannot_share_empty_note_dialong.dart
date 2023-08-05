import 'package:first_flutter/Utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an Empty Note',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
