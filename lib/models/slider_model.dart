import 'package:flutter/material.dart';

class SliderModel {
  final String id;
  final String imageUrl;
  final String link;
  final String textAction;
  final Color color;
  final String title;
  final String description;

  SliderModel({
    required this.id,
    required this.imageUrl,
    required this.link,
    required this.textAction,
    required this.color,
    required this.title,
    required this.description,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      link: json['link'] as String,
      textAction: json['textAction'] as String,
      color: json['color'] as Color,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'link': link,
      'textAction': textAction,
      'color': color,
      'title': title,
      'description': description,
    };
  }
}