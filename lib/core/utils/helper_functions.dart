
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class THelperFunctions{

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static void showAlertDialog(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Check if it's currently emergency time (10 PM - 7 AM Africa/Cairo)
  static bool isEmergencyTime() {
    final nowUtc = DateTime.now().toUtc();
    final cairoNow = nowUtc.add(const Duration(hours: 2));
    final hour = cairoNow.hour;
    // Emergency time: 10 PM (22:00) to 7 AM
    return hour >= 22 || hour < 7;
  }
}
