import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType { success, error, general }

class CustomSnackbar {
  static void show({
    required String message,
    SnackbarType type = SnackbarType.general,
  }) {
    Color backgroundColor = const Color(0xfff4f6ff);
    Color prussianBlue = const Color(0xff102B3F);
    Color moonStone = const Color(0xff53A2BE);

    Color iconColor;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        icon = Icons.check_circle_outline;
        iconColor = Colors.green;
        break;
      case SnackbarType.error:
        icon = Icons.error_outline;
        iconColor = Colors.red;
        break;
      case SnackbarType.general:
      default:
        icon = Icons.info_outline;
        iconColor = moonStone;
    }

    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: AutoSizeText(
        message,
        style: TextStyle(
          color: prussianBlue,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      icon: Container(
        margin: const EdgeInsets.only(left: 10),
        child: Icon(icon, color: iconColor, size: 28),
      ),
      backgroundColor: backgroundColor,
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderColor: moonStone.withOpacity(0.3),
      borderWidth: 1.5,
      boxShadows: [
        BoxShadow(
          color: prussianBlue.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }
}
