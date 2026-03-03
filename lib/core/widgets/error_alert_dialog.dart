import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';

class ErrorAlertDialog {
  const ErrorAlertDialog();

  static getDialog(BuildContext context, String error, {bool isPop = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(""),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (isPop) {
                  Navigator.pop(context);
                }
              },
              child: Text("ok".tr()),
            ),
          ],
        );
      },
    );
  }
}
