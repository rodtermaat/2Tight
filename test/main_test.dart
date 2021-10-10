import 'dart:convert';
import 'dart:math';
import 'package:test/test.dart';

import 'package:too_tight/models/food_class.dart';
import 'package:too_tight/models/date_calories.dart';
import 'package:too_tight/main.dart' as real_main;

void main() {
  //final List<Map<String, Object>> testFoodSharedPrefList = [
  //final List<String> testFoodSharedPrefList = [
  //{ "id": "2021-08-27 11:03:52.968609","date": "2021-08-25T09:55:25.135634","foodItem": "2 eggs","calories": 140},
  //{"id": "2021-08-27 10:47:26.870457","date": "2021-08-20T09:55:25.135634","foodItem": "3 eggs","calories": 210},
  //{"id": "2021-08-27 10:42:24.606545","date": "2021-08-18T09:55:25.135634","foodItem": "3 eggs","calories": 210},
  //{"id": "2021-08-27 10:44:31.221995","date": "2021-08-19T09:55:25.135634","foodItem": "3 eggs","calories": 210},
  //{"id": "2021-08-27 11:02:10.186896","date": "2021-08-24T09:55:25.135634","foodItem": "3 eggs","calories": 210},
  //{"id": "2021-08-27 10:59:06.760368","date": "2021-08-23T09:55:25.135634","foodItem": "3 eggs","calories": 210},
  //{"id": "2021-08-27 10:29:44.233171","date": "2021-08-16T09:55:25.135634","foodItem": "3 eggs","calories": 210},
  //{"id": "2021-08-27 10:50:31.552725","date": "2021-08-21T09:55:25.135634","foodItem": "320 wrap","calories": 300},
  //{"id": "2021-08-27 10:44:11.146528","date": "2021-08-19T09:55:25.135634","foodItem": "320 wrap","calories": 300}
  //];

  final List<FoodClass> userFoodListTestNoFoods = [];

  final List<FoodClass> userFoodListTest = [
    FoodClass(
        id: 'noFoods', date: DateTime.now(), foodItem: 'a food', calories: 250),
    FoodClass(
        id: 'noFoods', date: DateTime.now(), foodItem: 'a food', calories: 250),
    FoodClass(
        id: 'noFoods', date: DateTime.now(), foodItem: 'a food', calories: 225),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now(),
        foodItem: 'test food',
        calories: 300),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now(),
        foodItem: 'another food',
        calories: 400),
    FoodClass(
        id: 'noFoods', date: DateTime.now(), foodItem: 'pizza', calories: 500),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now().subtract(Duration(days: 1)),
        foodItem: 'Yesterday food',
        calories: 999),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now().subtract(Duration(days: 100)),
        foodItem: 'old food',
        calories: 500),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now().subtract(Duration(days: 100)),
        foodItem: 'old food',
        calories: 500),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now().subtract(Duration(days: 366)),
        foodItem: 'super old food',
        calories: 100),
  ];

  group('Shared Preferences operations', () {
    // test('Read shared pref from list to object', () {
    //   mapToObjectList = testFoodSharedPrefList
    //       .map((item) => FoodClass.fromMap(json.decode(item)))
    //       .toList();
    //   expect(mapToObjectList.length, 8);
    // });
    test('Shared Preferences object to json - userFoodList', () {
      List<String> spList =
          userFoodListTest.map((item) => json.encode(item.toMap())).toList();
      print(spList);
      expect(userFoodListTest.length, 10);
    });
    test('Test _todaysFoodList', () {
      List<FoodClass> todaysFoodListTest = userFoodListTest.where((fList) {
        DateTime theDate = DateTime.now();
        return fList.date.day == theDate.day &&
            fList.date.month == theDate.month &&
            fList.date.year == theDate.year;
      }).toList();
      expect(todaysFoodListTest.length, 6);
    });
    test('Test _userFoodListSortedDedup function', () {
      List<FoodClass> tempList = userFoodListTest;
      List<FoodClass> dedupList = [];
      bool ifFirstTime = true;
      String prevFoodItem = '';
      int prevCalories = 0;

      tempList.sort((a, b) => ("${a.foodItem}${a.calories}")
          .toLowerCase()
          .toString()
          .compareTo(("${b.foodItem}${b.calories}").toLowerCase().toString()));
      print(tempList);
      for (var i = 0; i < tempList.length; i++) {
        if (!ifFirstTime) {
          if (tempList[i].foodItem.toLowerCase() ==
                  prevFoodItem.toLowerCase() &&
              tempList[i].calories == prevCalories) {
          } else {
            dedupList.add(tempList[i]);
          }

          prevFoodItem = tempList[i].foodItem;
          prevCalories = tempList[i].calories;
        }
        if (ifFirstTime) {
          ifFirstTime = false;
          prevFoodItem = tempList[i].foodItem;
          prevCalories = tempList[i].calories;
          dedupList.add(tempList[i]);
        }
      }
      print(dedupList);
      expect(dedupList.length, 8);
      expect(dedupList[7].calories, 999);
    });
    test('Test _userFoodListSortedDedup function NO FOODS', () {
      List<FoodClass> tempList = userFoodListTestNoFoods;
      List<FoodClass> dedupList = [];
      bool ifFirstTime = true;
      String prevFoodItem = '';
      int prevCalories = 0;

      tempList.sort((a, b) => ("${a.foodItem}${a.calories}")
          .toLowerCase()
          .toString()
          .compareTo(("${b.foodItem}${b.calories}").toLowerCase().toString()));
      //print(tempList);
      for (var i = 0; i < tempList.length; i++) {
        if (!ifFirstTime) {
          if (tempList[i].foodItem.toLowerCase() ==
                  prevFoodItem.toLowerCase() &&
              tempList[i].calories == prevCalories) {
          } else {
            dedupList.add(tempList[i]);
          }

          prevFoodItem = tempList[i].foodItem;
          prevCalories = tempList[i].calories;
        }
        if (ifFirstTime) {
          ifFirstTime = false;
          prevFoodItem = tempList[i].foodItem;
          prevCalories = tempList[i].calories;
          dedupList.add(tempList[i]);
        }
      }
      //print(dedupList);
      expect(dedupList.length, 0);
      //expect(dedupList[5].calories, 999);
    });
    // test('Test calsByDate', () {
    //       List<DateCalories> calsGroupedByDateList =
    //     real_main.MyHomePage.calsGroupedByDate.map((item) => DateCalories.fromJson((item))).toList();
    // });
  });
}
