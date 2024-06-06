import 'package:flutter/material.dart';

class Dialogs {
  static void showSnacbar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(msg)),
        backgroundColor:color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(context: context, builder: (_) => Center(child: CircularProgressIndicator()));
  }
}
