//********************************************/
// Copyright 2021 Rod TerMaat (BigManSoftware)
// rodtermaat@gmail.com
// GNU General Public Lisense
//********************************************/

import 'package:flutter/foundation.dart';

class DateCalories {
  final DateTime date;
  final int calories;

  DateCalories({
    @required this.date,
    @required this.calories,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'calories': calories,
      };

  // DateCalories.fromMap(Map<String, Object> map)
  //     : this.date = DateTime.parse(map['date']),
  //       this.calories = map['calories'];

  factory DateCalories.fromJson(Map<String, dynamic> parsedJson) {
    return DateCalories(
        date: DateTime.parse(parsedJson['date']),
        calories: parsedJson['calories']);
  }
}
