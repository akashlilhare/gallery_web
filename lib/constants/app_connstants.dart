

import 'package:fluttertoast/fluttertoast.dart';

class AppConstants{
  static const apiKey = "43594279-d7d1bc7b843c78f24a539062b";
 static getToast(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,

        //    textColor: Colors.white,
        fontSize: 16.0);
  }
}