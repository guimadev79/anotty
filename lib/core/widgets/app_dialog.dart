import 'package:flutter/material.dart';

import 'app_button.dart';

class AppDialog {
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText),
            ),
            SizedBox(
              width: 120,
              child: AppButton(
                label: confirmText,
                onPressed: () => Navigator.pop(context, true),
              ),
            ),
          ],
        );
      },
    );
  }
}