import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String name;
  final double radius;

  const AppAvatar({
    super.key,
    required this.name,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty
        ? '?'
        : name.trim().substring(0, 1).toUpperCase();

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary.withValues(alpha: .12),
      child: Text(
        initial,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: radius * .8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}