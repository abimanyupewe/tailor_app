import 'package:flutter/material.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/core/constants/image_string.dart';

class AppData {
  static const List<Map<String, dynamic>> categories = [
    {
      'id': 'C001',
      'name': 'Wear',
      'iconUrl': ImageString.adultWear,
      'color': AppColors.pastelBlue,
    },
    {
      'id': 'C002',
      'name': 'Traditional Wear',
      'iconUrl': ImageString.traditionalWear,
      'color': AppColors.pastelPink,
    },
    {
      'id': 'C003',
      'name': 'Children\'s Wear',
      'iconUrl': ImageString.childrensWear,
      'color': AppColors.pastelPurple,
    },
    {
      'id': 'C004',
      'name': 'Bags & Accessories',
      'iconUrl': ImageString.bag,
      'color': AppColors.pastelBlue,
    },
    {
      'id': 'C005',
      'name': 'Shoes',
      'iconUrl': ImageString.shoes,
      'color': AppColors.pastelGreen,
    },
  ];
}
