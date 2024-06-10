
import 'package:flutter/material.dart';

class MyDateUtil {
  // for getting formatted time from millisecondssinceEpoch to string
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
        final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    return TimeOfDay.fromDateTime(date).format(context);
  }
}
