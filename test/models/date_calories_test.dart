import 'package:flutter_test/flutter_test.dart';

import 'food_class_test.dart';
import 'package:too_tight/models/date_calories.dart';

void main() {
  group('test date calories class', () {
    test('create date calories object', () {
      final dateCalories = DateCalories(date: DateTime.now(), calories: 325);
      expect(dateCalories.calories, 325);
    });
    test('to map and from json', () {
      final dateCalories = DateCalories(date: DateTime.now(), calories: 325);
      final Map dateCaloriesMap = dateCalories.toJson();
      final anotherDateCalories = DateCalories.fromJson(dateCaloriesMap);
      expect(anotherDateCalories.calories, 325);
    });
  });
}
