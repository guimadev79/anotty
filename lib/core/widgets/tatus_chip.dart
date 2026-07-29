import 'package:flutter/material.dart';

import '../theme/app_radius.dart';

enum StatusType {
  success,
  warning,
  error,
  info,
}

class StatusChip extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusChip({
    super.key,
    required this.label,
    required this.type,
  });

  Color get backgroundColor {
    switch (type) {
      case StatusType.success:
        return const Color(0xFFE8F8EE);
      case StatusType.warning:
        return const Color(0xFFFFF4E5);
      case StatusType.error:
        return const Color(0xFFFDECEC);
      case StatusType.info:
        return const Color(0xFFEAF2FF);
    }
  }

  Color get textColor {
    switch (type) {
      case StatusType.success:
        return const Color(0xFF16A34A);
      case StatusType.warning:
        return const Color(0xFFD97706);
      case StatusType.error:
        return const Color(0xFFDC2626);
      case StatusType.info:
        return const Color(0xFF2563EB);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}