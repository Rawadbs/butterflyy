import 'package:flutter/material.dart';

Color getColorForType(String type) {
  switch (type) {
    case 'صحية':
      return const Color(0xffFF8762);
    case 'شخصية':
      return const Color(0xff4B4DED);
    case 'دينية':
      return const Color(0xff986CF5);
    case 'مالية':
      return const Color(0xff31D097);
    default:
      return Colors.grey;
  }
}
