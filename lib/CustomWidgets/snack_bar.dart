import 'package:crc_app/styles.dart';
import 'package:flutter/material.dart';

enum SnackbarType { success, error, general }

class CustomSnackbar {
  final String message;
  final SnackbarType type;

  const CustomSnackbar({
    required this.message,
    this.type = SnackbarType.general,
  });

  // Color mapping for different snackbar types
  Color _getColor() {
    Color textColor;
    if (type == SnackbarType.success) {
      textColor = Colors.green;
    } else {
      textColor = Colors.red;
    }
    return textColor;
  }

  // Icon mapping for different snackbar types
  IconData _getIcon() {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle_outline;
      case SnackbarType.error:
        return Icons.error_outline;
      case SnackbarType.general:
      default:
        return Icons.info_outline;
    }
  }

  // Convert to SnackBar
  SnackBar build(BuildContext context) {
    return SnackBar(
      content: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon on the left
            Icon(
              _getIcon(),
              color: _getColor(),
              size: 28,
            ),
            const SizedBox(width: 16),

            // Message text
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(milliseconds: 1000),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.only(top: 50, left: 16, right: 16),
    );
  }
}
