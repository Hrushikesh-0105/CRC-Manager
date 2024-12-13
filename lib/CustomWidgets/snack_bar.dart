// import 'package:flutter/material.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

// SnackBar customSnackBar(String message) {
//   return SnackBar(
//     elevation: 0,
//     backgroundColor: Colors.transparent,
//     content: AwesomeSnackbarContent(
//         title: message, message: "", contentType: ContentType.success),
//     duration: const Duration(milliseconds: 5000),
//     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
//     // backgroundColor: Color(0xff333333),
//     behavior: SnackBarBehavior.floating,
//     // margin: const EdgeInsets.all(40),
//     // width: 20,
//   );
// }

// Center(
//   child: Text(
//     message,
//     style: const TextStyle(
//       fontSize: 16,
//       // fontFamily: customfontFamily,
//       color: Color(0xffF8F8F8),
//     ),
//   ),
// )

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
  Color _getBackgroundColor() {
    Color bgColor;
    if (type == SnackbarType.success) {
      bgColor = Colors.green;
    } else {
      bgColor = prussianBlue;
    }
    return bgColor;
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
          color: _getBackgroundColor(),
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
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 16),

            // Message text
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
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
      margin: const EdgeInsets.all(16),
    );
  }
}
