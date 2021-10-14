//********************************************/
// Copyright 2021 Rod TerMaat (BigManSoftware)
// rodtermaat@gmail.com
// GNU General Public Lisense
//********************************************/

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../models/date_calories.dart';

class SummaryGraph extends StatefulWidget {
  static const routeName = '/summary_graph';

  final List<DateCalories> calsGroupedByDateList;
  final Function updateCalorieGoal;
  final int currentCalorieGoal;

  SummaryGraph(this.calsGroupedByDateList, this.updateCalorieGoal,
      this.currentCalorieGoal);

  @override
  _SummaryGraphState createState() => _SummaryGraphState();
}

class _SummaryGraphState extends State<SummaryGraph> {
  final _form = GlobalKey<FormState>();
  var isInit = true;
  int newCalorieAmt;
  List<DateCalories> temp = [];

  @override
  void initState() {
    //print(widget.calsGroupedByDateList.length);
    //print(widget.calsGroupedByDateList);
    super.initState();
  }

  int get average7 {
    int cals = 0;
    int records = 0;

    temp = widget.calsGroupedByDateList.where((x) {
      return x.date.isAfter(DateTime.now().subtract(Duration(days: 8))) &&
          x.calories > 0 &&
          x.date.day != DateTime.now().day;
    }).toList();
    if (temp.length == 0) return 0;
    records = temp.length;
    cals = temp.fold(0, (calsPrev, calsNext) {
      return calsPrev + calsNext.calories;
    });
    return cals ~/ records;
  }

  int get average30 {
    int cals = 0;
    int records = 0;

    temp = widget.calsGroupedByDateList.where((x) {
      return x.date.isAfter(DateTime.now().subtract(Duration(days: 31))) &&
          x.calories > 0 &&
          x.date.day != DateTime.now().day;
    }).toList();
    if (temp.length == 0) return 0;
    records = temp.length;
    cals = temp.fold(0, (calsPrev, calsNext) {
      return calsPrev + calsNext.calories;
    });
    return cals ~/ records;
  }

  int get averageAll {
    int cals = 0;
    int records = 0;

    temp = widget.calsGroupedByDateList.where((x) {
      return x.date.isAfter(DateTime.now().subtract(Duration(days: 364))) &&
          x.calories > 0 &&
          x.date.day != DateTime.now().day;
    }).toList();
    if (temp.length == 0) return 0;
    records = temp.length;
    cals = temp.fold(0, (calsPrev, calsNext) {
      return calsPrev + calsNext.calories;
    });
    return cals ~/ records;
  }

  int get bingeCals {
    int cals = 0;

    temp = widget.calsGroupedByDateList.where((x) {
      return x.date.isAfter(findFirstDateOfTheWeek(DateTime.now())) &&
          x.date.day != DateTime.now().day;
      //&& x.date.isBefore(findLastDateOfTheWeek(DateTime.now()));
    }).toList();
    for (var i = 0; i < temp.length; i++) {
      if (temp[i].calories > 0)
        cals = cals + (widget.currentCalorieGoal - temp[i].calories);
      //print(temp[i].date.toString() + ' : ' + temp[i].calories.toString());
    }
    //print('first date: ' + findFirstDateOfTheWeek(DateTime.now()).toString());
    //print('last date: ' + findLastDateOfTheWeek(DateTime.now()).toString());
    // cals = temp.fold(0, (calsPrev, calsNext) {
    //   return calsPrev + calsNext.calories;
    // });
    //print('binge cals: ' + cals.toString());
    return cals;
  }

  int get bingeCalsPrev {
    //print('bingeCalsPrev');
    int cals = 0;

    temp = widget.calsGroupedByDateList.where((x) {
      return x.date.isAfter(findFirstDateOfTheWeek(
              DateTime.now().subtract(Duration(days: 7)))) &&
          x.date.isBefore(findLastDateOfTheWeek(
              DateTime.now().subtract(Duration(days: 7))));
    }).toList();
    for (var i = 0; i < temp.length; i++) {
      if (temp[i].calories > 0)
        cals = cals + (temp[i].calories - widget.currentCalorieGoal);
      // print(temp[i].date.toString() +
      //     ' : ' +
      //     temp[i].calories.toString() +
      //     ' - ' +
      //     widget.currentCalorieGoal.toString() +
      //     ' = ' +
      //     cals.toString());
    }
    // print('first date: ' +
    //     findFirstDateOfTheWeek(DateTime.now().subtract(Duration(days: 7)))
    //         .toString());
    // print('last date: ' +
    //     findLastDateOfTheWeek(DateTime.now().subtract(Duration(days: 7)))
    //         .toString());
    // // cals = temp.fold(0, (calsPrev, calsNext) {
    // //   return calsPrev + calsNext.calories;
    // // });
    // print('binge cals: ' + cals.toString());
    return cals;
  }

  // Find the first date of the week which contains the provided date.
  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    //return dateTime.subtract(Duration(days: dateTime.weekday - 1));
    return dateTime.subtract(Duration(days: dateTime.weekday));
  }

  // Find last date of the week which contains provided date.
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    //print('newCalorieAmt ' + newCalorieAmt.toString());
    widget.updateCalorieGoal(newCalorieAmt);

    //_form.currentState.reset();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('manage calories'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              child: Form(
                key: _form,
                child: Container(
                  //padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue: widget.currentCalorieGoal.toString(),
                          decoration:
                              const InputDecoration(labelText: 'calorie goal'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'really?';
                            }
                            if (int.tryParse(value) == null) {
                              return 'numbers only';
                            }
                            if (int.parse(value) < 0) {
                              return 'nope';
                            }
                            if (int.parse(value) == 0) {
                              return 'try again';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            //print('value ' + value);
                            newCalorieAmt = int.parse(value);
                          },
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: () {
                              _saveForm();
                            },
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 20, right: 30, left: 30, bottom: 20),
              child: const Text(
                'average daily calories: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        child: Text(average7.toString()),
                      ),
                      Center(
                        child: const Text('..last 7 days'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            child: Text(average30.toString()),
                          ),
                          Center(
                            child: const Text('..last 30 days'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        child: Text(averageAll.toString()),
                      ),
                      Center(
                        child: const Text('..lifetime'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, right: 5, left: 5),
              child: const Divider(
                height: 5,
                thickness: 5,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 20, right: 30, left: 30, bottom: 15),
              child: const Text(
                'weekly binge calories: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (bingeCals > 0)
              CircularPercentIndicator(
                radius: 150.0,
                animation: true,
                animationDuration: 1200,
                lineWidth: 15.0,
                percent: bingeCals / (widget.currentCalorieGoal * 7),
                center: new Text(
                  bingeCals.toString() + ' cals ',
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                circularStrokeCap: CircularStrokeCap.butt,
                backgroundColor: Colors.cyan[200],
                progressColor: Colors.amber,
              ),
            if (bingeCals <= 0)
              CircularPercentIndicator(
                radius: 150.0,
                animation: true,
                animationDuration: 1200,
                lineWidth: 15.0,
                percent: 0,
                center: new Text(
                  bingeCals.toString() + ' cals ',
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                circularStrokeCap: CircularStrokeCap.butt,
                backgroundColor: Colors.cyan[200],
                progressColor: Colors.amber,
              ),
            Container(
              padding: const EdgeInsets.only(
                  top: 10, right: 50, left: 20, bottom: 0),
              child: Text(
                '..last weeks over/under: ' + bingeCalsPrev.toString(),
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
