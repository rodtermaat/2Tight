import 'package:flutter/material.dart';

import '../models/food_class.dart';

class CaloriesEaten extends StatelessWidget {
  final List<FoodClass> todaysFoodList;
  final calorieGoal;

  CaloriesEaten(this.todaysFoodList, this.calorieGoal);

  int get calcCals {
    return todaysFoodList.fold(0, (calsLeft, foodCal) {
      return calsLeft + foodCal.calories;
    });
  }

  @override
  Widget build(BuildContext context) {
    //print('CaloriesEaten instanciated - widget build');
    return Stack(
      children: [
        if (calcCals == 0)
          LinearProgressIndicator(
            backgroundColor: Theme.of(context).primaryColorLight,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber[200]),
            value: 0,
            //value: calcCals() / goalCalories(),
            minHeight: 10,
          ),
        if (calcCals > 0)
          LinearProgressIndicator(
            backgroundColor: Theme.of(context).primaryColorLight,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber[200]),
            value: calcCals / calorieGoal,
            //value: calcCals() / goalCalories(),
            minHeight: 10,
          ),
        if (calcCals == 0)
          Align(
              alignment:
                  Alignment.lerp(Alignment.topLeft, Alignment.topRight, 0),
              child: Text(
                calcCals.toString(),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              )),
        if (calcCals > 0 && calcCals < calorieGoal)
          Align(
              alignment: Alignment.lerp(Alignment.topLeft, Alignment.topRight,
                  (calcCals / calorieGoal)),
              //Alignment.topLeft, Alignment.topRight, (((calcCals()) / 2000))),
              child: Text(
                calcCals.toString(),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              )),
        if (calcCals >= calorieGoal)
          Align(
              alignment:
                  Alignment.lerp(Alignment.topLeft, Alignment.topRight, 1),
              child: Text(
                calcCals.toString(),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              )),
        if (calcCals / calorieGoal < .85)
          Align(
            alignment: Alignment.lerp(Alignment.topLeft, Alignment.topRight, 1),
            child: Text(
              calorieGoal.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}
