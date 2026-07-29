import 'package:flutter/material.dart';

class AppShadows {
  static const soft = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const medium = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 30,
      offset: Offset(0, 12),
    ),
  ];
}