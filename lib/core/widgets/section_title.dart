import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onPressed;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.h2,
          ),
        ),
        if (actionText != null)
          TextButton(
            onPressed: onPressed,
            child: Text(actionText!),
          ),
      ],
    );
  }
}