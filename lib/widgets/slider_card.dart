import 'package:flutter/material.dart';
import 'package:tailor_app/models/slider_model.dart';

class SliderCard extends StatelessWidget {
  final SliderModel data;
  const SliderCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Misal: buka link data.link
      },
      child: Container(
        width: double.infinity,
        height: 250.0,
        decoration: BoxDecoration(
          color: data.color,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset(data.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
