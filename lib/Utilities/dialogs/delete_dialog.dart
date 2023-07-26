import 'package:first_flutter/Utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete Note',
    content: 'Are you sure you want to delete?',
    optionBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then(
        (value) => value ?? false,
  );
}