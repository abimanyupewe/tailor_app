import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/core/constants/image_string.dart';

class DataSlider {
  DataSlider();

  final List<Map<String, dynamic>> data = [
    {
      'id': 'S001',
      'imageUrl': ImageString.banner1,
      'link': '',
      'color': AppColors.pastelBlue,
      'textAction': 'Order Now',
      'title': 'Summer Collection',
      'description':
          'Explore our new summer collection with vibrant colors and styles.',
    },
    {
      'id': 'S002',
      'imageUrl': ImageString.banner2,
      'link': '',
      'color': AppColors.pastelYellow,
      'textAction': 'Explore Now',
      'title': 'Tailoring Services',
      'description':
          'Get your clothes tailored to perfection by our expert tailors.',
    },
    {
      'id': 'S003',
      'imageUrl': ImageString.banner3,
      'link': '',
      'color': AppColors.pastelPurple,
      'textAction': 'Shop Now',
      'title': 'Exclusive Offers',
      'description':
          'Avail exclusive discounts on selected tailoring services this month.',
    },
  ];
}

class DataCategory {
  DataCategory();

  final List<Map<String, dynamic>> data = [
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
