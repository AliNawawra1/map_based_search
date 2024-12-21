import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationServices {
  /// Display a generic SnackBar with customizable parameters
  static void showSnackBar({
    required String title,
    required String message,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = Colors.blueAccent,
    Color textColor = Colors.white,
    SnackBarAction? action,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      duration: duration,
      backgroundColor: backgroundColor,
      colorText: textColor,
      snackStyle: SnackStyle.FLOATING,
      mainButton: action != null
          ? TextButton(
              onPressed: action.onPressed,
              child: Text(action.label, style: TextStyle(color: textColor)),
            )
          : null,
    );
  }

  /// Convenience method for error SnackBar
  static void showErrorSnackBar(String message) {
    showSnackBar(
      title: "Error",
      message: message,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
  }

  /// Convenience method for success SnackBar
  static void showSuccessSnackBar(String message) {
    showSnackBar(
      title: "Success",
      message: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Convenience method for info SnackBar
  static void showInfoSnackBar(String message) {
    showSnackBar(
      title: "Info",
      message: message,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
    );
  }
}
