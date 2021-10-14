//********************************************/
// Copyright 2021 Rod TerMaat (BigManSoftware)
// rodtermaat@gmail.com
// GNU General Public Lisense
//********************************************/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './widgets/word_cloud.dart';
import './widgets/calories_eaten.dart';
import './screens/summary_graph.dart';
import './screens/weight_analytics.dart';
import './widgets/new_food.dart';
import './models/food_class.dart';
import './models/date_calories.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pants Too Tight',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        accentColor: Colors.amber,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<FoodClass> _userFoodList = [];
  List<DateCalories> calsGroupedByDateList = [];
  DateTime theDate = DateTime.now();
  SharedPreferences sharedPreferences;
  int globalCalories = 0;

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  //-----------------------------------------------------------------------
  //  Load data from shared preferences into a FoodClass list and save it
  //  ! this is the primary list for the entire program
  //-----------------------------------------------------------------------
  Future<void> initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    // only user to clear out shared preferences for testing:
    //sharedPreferences.clear();
    loadSharedDataFoods();
    globalCalories = sharedPreferences.getInt('calories') ?? 2000;
  }

  void saveSharedDataCalories(int calories) {
    sharedPreferences.setInt('calories', calories);
    globalCalories = calories;
    //globalCalories = sharedPreferences.getInt('calories') ?? 2000;
    if (globalCalories == 0) globalCalories = 2000;
    setState(() {});
  }

  void loadSharedDataFoods() {
    List<String> spList = sharedPreferences.getStringList('foodDay');
    //print(spList);
    if (spList?.isEmpty ?? true) return;
    if (spList.isNotEmpty) {
      _userFoodList =
          spList.map((item) => FoodClass.fromMap(json.decode(item))).toList();
      setState(() {});
    }
  }

  void saveSharedDataFoods() {
    List<String> spList =
        _userFoodList.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('foodDay', spList);
  }
  // ---------------- End of shared preferences codes -------------------

  void _showAddDialog(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
            onTap: () {},
            child: NewFood(_addNewFood, _userFoodListSortedDedup),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  // create list of food from today for WordCloud
  List<FoodClass> get _todaysFoodList {
    return _userFoodList.where((fList) {
      return fList.date.day == theDate.day &&
          fList.date.month == theDate.month &&
          fList.date.year == theDate.year;
    }).toList();
  }

  // create list for NewFood to do Search so user can reuse past entries
  List<FoodClass> get _userFoodListSortedDedup {
    List<FoodClass> tempList = _userFoodList;
    List<FoodClass> dedupList = [];
    bool ifFirstTime = true;
    String prevFoodItem = '';
    int prevCalories = 0;

    tempList.sort((a, b) => ("${a.foodItem}${a.calories}")
        .toLowerCase()
        .toString()
        .compareTo(("${b.foodItem}${b.calories}").toLowerCase().toString()));

    for (var i = 0; i < tempList.length; i++) {
      //print('ifFirstTime : $ifFirstTime');
      //print('prevFoodItem : $prevFoodItem - prevCalories : $prevCalories');
      //print('currentFood : ${tempList[i].foodItem} - currentCals : ${tempList[i].calories}');

      if (!ifFirstTime) {
        if (tempList[i].foodItem.toLowerCase() == prevFoodItem.toLowerCase() &&
            tempList[i].calories == prevCalories) {
          //print('duplicate to remove');
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
    //return tempList;
    return dedupList;
  }

  //  List summarized by date and calories to SummaryGraph
  List<DateCalories> get calsByDate {
    calsGroupedByDateList =
        calsGroupedByDate.map((item) => DateCalories.fromJson((item))).toList();
    return calsGroupedByDateList;
  }

  // List of Maps called by calsByDate to build a look back or 365 days to feed
  // the SummaryGraph averages and binge calories
  List<Map<String, Object>> get calsGroupedByDate {
    return List.generate(365, (index) {
      final dateTotal = DateTime.now().subtract(
        Duration(days: index),
      );
      int totCals = 0;
      for (var i = 0; i < _userFoodList.length; i++) {
        if (_userFoodList[i].date.day == dateTotal.day &&
            _userFoodList[i].date.month == dateTotal.month &&
            _userFoodList[i].date.year == dateTotal.year) {
          totCals += _userFoodList[i].calories;
        }
      }
      return {'date': dateTotal.toIso8601String(), 'calories': totCals};
    }).toList();
  }

  // CRUD code for Edit/Update
  void _editFood(String editId, String editFoodItem, int editCalories) {
    if (editId == 'noFoods') {
      return;
    }
    final foodIndex = _userFoodList.indexWhere((foodi) => foodi.id == editId);
    if (foodIndex >= 0) {
      setState(() {
        final updatedFoodObject = FoodClass(
            id: editId,
            date: theDate,
            foodItem: editFoodItem,
            calories: editCalories);
        _userFoodList[_userFoodList
                .indexWhere((element) => element.id == updatedFoodObject.id)] =
            updatedFoodObject;
        saveSharedDataFoods();
      });
    } else {
      //print('serious update shit show');
    }
  }

  // CRUD for add
  void _addNewFood(String newFoodItem, int newCalories) {
    final newFood = FoodClass(
        id: DateTime.now().toString(),
        date: theDate,
        foodItem: newFoodItem,
        calories: newCalories);

    setState(() {
      _userFoodList.add(newFood);
      saveSharedDataFoods();
    });
  }

  // CRUD to copy to today
  void _copyFood(String copyFoodItem, int copyCalories) {
    final copyFood = FoodClass(
        id: DateTime.now().toString(),
        date: DateTime.now(),
        foodItem: copyFoodItem,
        calories: copyCalories);

    setState(() {
      _userFoodList.add(copyFood);
      saveSharedDataFoods();
    });
  }

  // CRUD to delete a food
  void _deleteFood(String id) {
    if (id == 'noFoods') {
      return;
    }
    setState(() {
      _userFoodList.removeWhere((afood) {
        return afood.id == id;
      });
      saveSharedDataFoods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final appBar = AppBar(
      leading: IconButton(
          icon: const Icon(Icons.speed),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return WeightAnalytics();
              //return WeightTracking();
            }));
          }),
      title: Row(
        children: [
          Text(
            DateFormat('EEEE, MMM d, yy').format(theDate),
            style: const TextStyle(fontSize: 18),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.bar_chart),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return SummaryGraph(
                  calsByDate, saveSharedDataCalories, globalCalories);
            }));
          },
        )
      ],
    );

    return Scaffold(
        appBar: appBar,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _showAddDialog(context),
        ),
        body: Dismissible(
          //key: new ValueKey(_counter),
          key: UniqueKey(),
          resizeDuration: null,
          onDismissed: (DismissDirection direction) {
            // move date forward
            if (direction == DismissDirection.endToStart) {
              //print('endt to start');
              moveDateForward();
            }
            // move date backward
            if (direction == DismissDirection.startToEnd) {
              //print('start to end');
              moveDateBackwards();
            }
            return Future.value(false);
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 5),
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top
                        //- 10
                        ) *
                        .10,
                    child: CaloriesEaten(_todaysFoodList, globalCalories)),
                Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        .85,
                    //child: FoodList(_todaysFoodList, _deleteFood)),
                    child: WordCloud(
                        _todaysFoodList,
                        (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            .85,
                        _deleteFood,
                        _editFood,
                        _copyFood)),
              ],
            ),
          ),
        ));
  }

  // code to navigate the date
  moveDateForward() {
    setState(() {
      theDate = theDate.add(Duration(days: 1));
    });
  }

  moveDateBackwards() {
    setState(() {
      theDate = theDate.subtract(Duration(days: 1));
    });
  }
}
