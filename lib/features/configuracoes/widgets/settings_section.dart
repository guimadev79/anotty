import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: AppTextStyles.h3,
        ),

        const SizedBox(height: 16),

        ...children,

        const SizedBox(height: 28),
      ],
    );
  }
}