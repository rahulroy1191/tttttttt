import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void snackbarMessage(BuildContext context, String message,
    [bool isErrorMessage = false]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isErrorMessage? Colors.red:null,
      content: Text(message),
    ),
  );
}
