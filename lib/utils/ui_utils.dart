import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import 'constants.dart';

class UiUtils {
  /// Returns the appropriate color for an order status.
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case AppConstants.statusPending:
        return Colors.orange;
      case AppConstants.statusAtWarehouse:
        return Colors.indigo;
      case AppConstants.statusOnDelivery:
        return Colors.blue;
      case AppConstants.statusDelivered:
        return Colors.green;
      case AppConstants.statusCompleted:
        return AppColors.primary;
      default:
        return Colors.grey;
    }
  }

  /// Returns the appropriate color for a user role.
  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case AppConstants.roleAdmin:
        return AppColors.primary;
      case AppConstants.roleCourier:
        return Colors.orange;
      case AppConstants.roleWarehouse:
      case 'gudang':
        return Colors.indigo;
      case AppConstants.roleCustomer:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Shows a success snackbar.
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows an error snackbar.
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
