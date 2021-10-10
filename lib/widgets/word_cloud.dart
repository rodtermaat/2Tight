import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_scatter/flutter_scatter.dart';
import '../models/food_class.dart';
import './edit_food.dart';

class WordCloud extends StatelessWidget {
  final List<FoodClass> todaysFoodList;
  final double widgetHeight;
  final Function deleteFood;
  final Function editFood;
  final Function copyFood;

  static final List<FoodClass> seedFoodList = [
    FoodClass(
        id: 'noFoods',
        date: DateTime.now(),
        foodItem: 'Enter foods',
        calories: 500),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now(),
        foodItem: 'Enter calories',
        calories: 500),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now(),
        foodItem: 'Track calories eaten',
        calories: 400),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now(),
        foodItem: 'Tap to edit',
        calories: 300),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now(),
        foodItem: 'Press to copy',
        calories: 300),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now(),
        foodItem: 'Calorie Averages',
        calories: 400),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now(),
        foodItem: 'Binge calories',
        calories: 500),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now(),
        foodItem: 'Pants 2 Tight?',
        calories: 999),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now(),
        foodItem: 'Weight tracking',
        calories: 400),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now(),
        foodItem: 'Weight analytics',
        calories: 275),
    FoodClass(
        id: 'noFoods',
        date: DateTime.now(),
        foodItem: 'Calorie analytics',
        calories: 525),
  ];

  WordCloud(this.todaysFoodList, this.widgetHeight, this.deleteFood,
      this.editFood, this.copyFood);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];

    if (todaysFoodList.isEmpty) {
      for (var i = 0; i < seedFoodList.length; i++) {
        widgets.add(
            ScatterItem(seedFoodList[i], i, deleteFood, editFood, copyFood));
      }
    } else {
      for (var i = 0; i < todaysFoodList.length; i++) {
        widgets.add(
            ScatterItem(todaysFoodList[i], i, deleteFood, editFood, copyFood));
      }
    }

    final screenSize = MediaQuery.of(context).size;
    //final ratio = screenSize.width / screenSize.height * 2;
    final ratio = screenSize.width / widgetHeight * 2;

    return InteractiveViewer(
      child: Center(
        child: FittedBox(
          child: Scatter(
            //fillGaps: true,
            fillGaps: false,
            delegate: ArchimedeanSpiralScatterDelegate(ratio: ratio),
            children: widgets,
          ),
        ),
      ),
    );
  }
}

class ScatterItem extends StatelessWidget {
  ScatterItem(this.foodClass, this.index, this.deleteFood, this.editFood,
      this.copyFood);
  final FoodClass foodClass;
  final int index;
  final Function deleteFood;
  final Function editFood;
  final Function copyFood;

  @override
  Widget build(BuildContext context) {
    //random bool to determine if the RotatedBox should be rotated
    final randomBool = math.Random();

    final TextStyle style = Theme.of(context).textTheme.bodyText2.copyWith(
          fontSize: foodClass.calories.toDouble() >= 100
              ? foodClass.calories.toDouble() / 2.5
              : foodClass.calories.toDouble() / 1.1,
          //fontSize: hashtag.size.toDouble() / 2.5,

          //various ways to generate random colors - experimental
          //color: hashtag.color,
          //color: Colors.primaries[math.Random().nextInt(Colors.primaries.length)];
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
        );
    return GestureDetector(
      onTap: () {
        //print('you selected edit');
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) {
              return EditFood(editFood, deleteFood, foodClass.id,
                  foodClass.foodItem, foodClass.calories.toString());
            });
      },
      onLongPress: () {
        //print('you selected delete');
        return showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text("Copy Food?"),
                content: const Text("Copy food to today"),
                actions: [
                  TextButton(
                    child: const Text("cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("copy to today"),
                    onPressed: () {
                      if (foodClass.id != 'noFoods')
                        copyFood(foodClass.foodItem, foodClass.calories);
                      //deleteFood(foodClass.id);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        // print(foodClass.foodItem +
        //     ' : ' +
        //     foodClass.calories.toString() +
        //     ' (cals)');
      },
      child: RotatedBox(
          //quarterTurns: hashtag.rotated ? 1 : 0,
          quarterTurns: randomBool.nextBool() ? 1 : 0,
          child: Row(children: [
            CircleAvatar(
              //minRadius: 75,
              radius: 75,
              child: FittedBox(
                child: Text(
                  foodClass.calories.toString(),
                  style: const TextStyle(fontSize: 42),
                ),
              ),
            ),
            Text(
              foodClass.foodItem,
              style: style,
            ),
          ])),
    );
  }
}
