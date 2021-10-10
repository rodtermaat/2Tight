import 'package:test/test.dart';
import 'package:too_tight/models/food_class.dart';

void main() {
  group('test food class model', () {
    test('foodclass model', () {
      final foodClass = FoodClass(
          id: DateTime.now().toIso8601String(),
          date: DateTime.now(),
          foodItem: 'a food item',
          calories: 250);
      expect(foodClass.foodItem, 'a food item');
    });
    test('foodclass to map', () {
      final foodClass = FoodClass(
          id: DateTime.now().toIso8601String(),
          date: DateTime.now(),
          foodItem: 'a food item',
          calories: 250);
      Map foodClassMap = foodClass.toMap();
      expect(foodClassMap['calories'], 250);
      expect(foodClassMap['foodItem'], 'a food item');
    });
    test('food class fromMap', () {
      final foodClass = FoodClass(
          id: DateTime.now().toIso8601String(),
          date: DateTime.now(),
          foodItem: 'a food item',
          calories: 250);
      Map foodClassMap = foodClass.toMap();
      final anotherFoodClass = FoodClass.fromMap(foodClassMap);
      expect(anotherFoodClass.foodItem, 'a food item');
    });
  });
}
