import 'package:chat_app/headers.dart';

class MyDateUtil {
  //for getting formated time from epoch string
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));

    return TimeOfDay.fromDateTime(date).format(context);
  }
}
