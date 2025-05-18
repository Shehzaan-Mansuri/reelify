import 'package:flutter/material.dart';

/// A utility class that provides methods for displaying different types of SnackBar alerts.
///
/// This class contains static methods to show success, error, information, and warning
/// messages to the user via SnackBars with appropriate colors.
///
/// Example usage:
/// ```dart
/// AlertUtils.showSuccessSnackBar(context, 'Operation completed successfully');
/// ```
///
/// All SnackBars are configured with [SnackBarBehavior.floating] for a more
/// modern look that overlays the bottom content rather than pushing it up.
class AlertUtils {
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
