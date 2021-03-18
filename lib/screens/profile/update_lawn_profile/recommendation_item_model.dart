import 'package:flutter/material.dart';

class RecommendationItem {
  Color color;
  String imageUrl;
  DateTime startDate;
  DateTime endDate;
  String itemName;
  String price;
  bool isNew;

  RecommendationItem({
    this.color,
    this.imageUrl,
    this.startDate,
    this.endDate,
    this.itemName,
    this.price,
    this.isNew,
  });
}