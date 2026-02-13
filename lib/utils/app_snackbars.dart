import 'package:flutter/material.dart';

/// Utility class for showing consistent snackbars throughout the app
class AppSnackBars {
  /// Shows a success snackbar
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(context, message, SnackBarType.success);
  }

  /// Shows an error snackbar
  static void showError(BuildContext context, String message) {
    _showSnackBar(context, message, SnackBarType.error);
  }

  /// Shows an info snackbar
  static void showInfo(BuildContext context, String message) {
    _showSnackBar(context, message, SnackBarType.info);
  }

  /// Shows a warning snackbar
  static void showWarning(BuildContext context, String message) {
    _showSnackBar(context, message, SnackBarType.warning);
  }

  /// Shows a generic snackbar with custom message
  static void show(BuildContext context, String message) {
    _showSnackBar(context, message, SnackBarType.normal);
  }

  static void _showSnackBar(BuildContext context, String message, SnackBarType type) {
    final theme = Theme.of(context);
    Color backgroundColor;
    IconData? icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = Colors.green[600] ?? Colors.green;
        icon = Icons.check_circle;
        break;
      case SnackBarType.error:
        backgroundColor = Colors.red[600] ?? Colors.red;
        icon = Icons.error;
        break;
      case SnackBarType.warning:
        backgroundColor = Colors.orange[600] ?? Colors.orange;
        icon = Icons.warning;
        break;
      case SnackBarType.info:
        backgroundColor = Colors.blue[600] ?? Colors.blue;
        icon = Icons.info;
        break;
      case SnackBarType.normal:
        backgroundColor = theme.colorScheme.surface;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        elevation: 6,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

enum SnackBarType { success, error, info, warning, normal }
