import 'package:flutter/material.dart';

import '../theme/app_pallete.dart';

class AppSnackbar {
  static void showSnackabar(
    BuildContext context, {
    required String content,
    bool isError = true,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            content,
            style: TextStyle(color: isError ? Colors.white : null),
          ),
          backgroundColor: isError ? Pallete.errorColor : null,
        ),
      );
  }
}
