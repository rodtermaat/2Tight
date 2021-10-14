//********************************************/
// Copyright 2021 Rod TerMaat (BigManSoftware)
// rodtermaat@gmail.com
// GNU General Public Lisense
//********************************************/

import 'package:flutter/foundation.dart';

class FoodClass {
  final String id;
  final DateTime date;
  final String foodItem;
  final int calories;

  FoodClass({
    @required this.id,
    @required this.date,
    @required this.foodItem,
    @required this.calories,
  });

  @override
  String toString() {
    return '$foodItem ($calories)';
  }

  FoodClass.fromMap(Map map)
      : this.id = map['id'],
        this.date = DateTime.parse(map['date']),
        this.foodItem = map['foodItem'],
        this.calories = map['calories'];

  Map toMap() {
    return {
      'id': this.id,
      'date': this.date.toIso8601String(),
      'foodItem': this.foodItem,
      'calories': this.calories
    };
  }
}
