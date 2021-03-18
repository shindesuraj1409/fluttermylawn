import 'package:flutter/material.dart';
import 'package:bus/bus.dart';

class ThemeModel with Bus {
  ThemeModel({
    ThemeData themeData,
  }) {
    publish(data: themeData ?? ThemeData.light());
  }

  @override
  List<Channel> get channels => [Channel(ThemeData)];
}
