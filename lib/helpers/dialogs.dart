import 'package:flutter/material.dart';

class Dialogs {
  static void showSnacbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(msg)),
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(context: context, builder: (_) => Center(child: CircularProgressIndicator()));
  }
}
