import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// void showToast(final String message) {
//   Fluttertoast.showToast(
//     msg: message,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.CENTER,
//     backgroundColor: Colors.black,
//     textColor: Colors.white,
//     fontSize: 16.0,
//   );
// }

Future<bool> isInternetConnected() async {
  final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi)) {
    return true;
  }

  return false;
}

void customPrint(final Object? value) {
  if (kDebugMode) {
    print(value);
  }
}

void showLoaderDialog(final BuildContext context, final String? message) {
  final alert = AlertDialog(
    content: Row(
      children: [
        CircularProgressIndicator(),
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(message ?? ''),
        ),
      ],
    ),
  );
  showDialog<AlertDialog>(
    barrierDismissible: false,
    context: context,
    useRootNavigator: false,
    builder: (final BuildContext context) => alert,
  );
}

void showIOSAlertDialog(
  final BuildContext context, {
  required final String title,
  final String? subtitle,
}) {
  showCupertinoDialog<void>(
    context: context,
    builder: (final BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(subtitle ?? ''),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          textStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

void popDialog(final BuildContext context) {
  Navigator.pop(context);
}
