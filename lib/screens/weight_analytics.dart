import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:too_tight/widgets/just_the_facts.dart';

import '../models/weight_class.dart';
import '../widgets/new_weight.dart';

class WeightAnalytics extends StatefulWidget {
  @override
  _WeightAnalyticsState createState() => _WeightAnalyticsState();
}

class _WeightAnalyticsState extends State<WeightAnalytics> {
  List<WeightClass> _userWeightList = [];
  Future<List<WeightClass>> _futureWeightList;

  // goal weight and newgoalweight
  Future<int> _goalWeight;
  int _userGoalWeight;
  final newGoalWeightController = TextEditingController();

  @override
  initState() {
    super.initState();
    //print('initstate - getWeightAmt');
    //SharedPreferencesHelper.clearSharedPreferences();
    loadGoalWeight();
    loadUserWeightList();
  }

  void loadGoalWeight() async {
    //print('calling loadGoalWeight');
    _goalWeight = SharedPreferencesHelper.getWeightAmt();
    _userGoalWeight = await _goalWeight;
    newGoalWeightController.text = _goalWeight.toString();
    //print('_userGoalWeight ' + _userGoalWeight.toString());
  }

  void loadUserWeightList() async {
    //print('in loadUserWeightList');
    _futureWeightList = SharedPreferencesHelper.getWeightList();
    _userWeightList = await _futureWeightList;
    //print(_userWeightList);
  }

  void submitData() async {
    if (newGoalWeightController.text.isEmpty) return;
    if (int.tryParse(newGoalWeightController.text) == null) return;
    if (int.parse(newGoalWeightController.text) < 0) return;
    final newWeightAmt = int.tryParse(newGoalWeightController.text);
    await SharedPreferencesHelper.setWeightAmt(newWeightAmt);
    setState(() {
      _goalWeight = SharedPreferencesHelper.getWeightAmt();
      newGoalWeightController.text = _goalWeight.toString();
      loadGoalWeight();
      //loadGoalWeight();
    });
  }

  void _showAddDialog(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
            onTap: () {},
            child: NewWeight(_addNewWeight),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  // CRUD for add
  void _addNewWeight(DateTime theDate, double aNewWeight) {
    print('in _addNewWeight');
    final newWeight = WeightClass(
        id: DateTime.now().toString(), date: theDate, weight: aNewWeight);

    setState(() {
      //print('before add' + _userWeightList.toString());
      _userWeightList.add(newWeight);
      //print('after add' + _userWeightList.toString());
      SharedPreferencesHelper.setWeightList(_userWeightList);
      loadUserWeightList();
    });
  }

  // CRUD to delete a food
  void _deleteWeight(String id) {
    setState(() {
      _userWeightList.removeWhere((aWeight) {
        return aWeight.id == id;
      });
      SharedPreferencesHelper.setWeightList(_userWeightList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final appBar = AppBar(
      title: Text('manage weight'),
    );

    return Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddDialog(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top -
                      10) *
                  .11,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: FutureBuilder<int>(
                        future: _goalWeight,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<int> snapshot,
                        ) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Container();
                          }

                          newGoalWeightController.text =
                              snapshot.data.toString();
                          _userGoalWeight = snapshot.data;

                          return TextField(
                            decoration:
                                const InputDecoration(labelText: 'goal weight'),
                            controller: newGoalWeightController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
                            ],
                            onSubmitted: (_) => submitData(),
                          );
                        }),
                  ),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () async {
                          submitData();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text('new goal weight saved')));
                        },
                      ))
                ],
              ),
            ),
            Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  .12,
              padding: const EdgeInsets.only(
                  top: 20, right: 30, left: 30, bottom: 20),
              child: const Text(
                'just the facts: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  .15,
              child: FutureBuilder(
                //future: SharedPreferencesHelper.getWeightList(),
                future: _futureWeightList,
                builder: (context, futureFacts) {
                  if (futureFacts.connectionState != ConnectionState.done) {
                    return Container();
                  }
                  if (futureFacts.connectionState == ConnectionState.done &&
                      futureFacts.data == null) {
                    return Container();
                  } else {
                    _userWeightList = futureFacts.data;
                    if (_userWeightList.isEmpty) {
                      return JustTheFacts(0.0, 0.0, 0.0);
                    }

                    return JustTheFacts(
                        _userWeightList.first.weight,
                        _userWeightList.last.weight -
                            _userWeightList.first.weight,
                        _userWeightList.first.weight - _userGoalWeight);
                  }
                },
              ),
            ),
            Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  .03,
              padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
              child: const Divider(
                height: 3,
                thickness: 3,
              ),
            ),
            Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  .09,
              padding: const EdgeInsets.only(
                  top: 15, right: 30, left: 30, bottom: 0),
              child: const Text(
                'weight loss: ',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Container(
            //   height: (mediaQuery.size.height -
            //           appBar.preferredSize.height -
            //           mediaQuery.padding.top) *
            //       .08,
            //   padding: const EdgeInsets.only(
            //       top: 0, right: 50, left: 20, bottom: 10),
            //   child: const Text(
            //     '..enter weight to begin the journey',
            //     style:
            //         const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            //   ),
            // ),
            Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  .48,
              //height: 275,
              child: FutureBuilder(
                future: _futureWeightList,
                builder: (context, futureDataList) {
                  if (futureDataList.connectionState != ConnectionState.done) {
                    return Container();
                  }
                  if (futureDataList.connectionState == ConnectionState.done &&
                      futureDataList.data == null) {
                    return Container();
                  } else {
                    List<WeightClass> weightClassList =
                        futureDataList.data ?? [];

                    return ListView.builder(
                        itemCount: weightClassList.length,
                        itemBuilder: (_, i) {
                          WeightClass weightListItem = weightClassList[i];
                          return Dismissible(
                            key: Key(weightListItem.id),
                            background: Container(color: Colors.red),
                            onDismissed: (direction) {
                              // Remove the item from the data source.
                              setState(() {
                                weightClassList.removeAt(i);
                                _deleteWeight(weightListItem.id);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 1),
                                      content:
                                          const Text('weight record deleted')));
                            },
                            child: Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.only(
                                      top: 1, right: 15, left: 15, bottom: 0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        //leading: weightList.id,
                                        title: Text(
                                            weightListItem.weight.toString()),
                                        subtitle: Text(DateFormat.yMd()
                                            .format(weightListItem.date)),
                                        trailing: Text(weightListItem.weightDiff
                                            .toStringAsFixed(2)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SharedPreferencesHelper {
  // Instantiation of the SharedPreferences library
  static final String _weightKey = "weightGoal";
  static final String _weightListKey = "userWeightList";

  static void clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // Method that returns the user goal weight, 150 if not set
  static Future<int> getWeightAmt() async {
    //print('getWeightAmt');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_weightKey) ?? 150;
  }

  // Method that saves the user weight goal
  static Future<bool> setWeightAmt(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_weightKey, value);
  }

  static Future<List<WeightClass>> getWeightList() async {
    //print('getWeightList');
    List<WeightClass> _spWeightList = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> spList = prefs.getStringList(_weightListKey);
    // if (_spWeightList.isEmpty) {
    //   print('adding a record');
    //   _spWeightList.add(WeightClass(
    //       id: DateTime.now().toIso8601String(),
    //       date: DateTime.now(),
    //       weight: 150));
    // }
    if (spList?.isEmpty ?? true) return _spWeightList;
    if (spList.isNotEmpty) {
      _spWeightList =
          spList.map((item) => WeightClass.fromMap(json.decode(item))).toList();
    }

    //print(_spWeightList);

    _spWeightList.sort((b, a) {
      return a.date
          .toString()
          .toLowerCase()
          .compareTo(b.date.toString().toLowerCase());
    });

    final List<WeightClass> _finalWeightList = [];
    bool firstTime = true;
    String holdId;
    DateTime holdDate;
    double holdWeight;
    double holdWeightDiff;
    for (var i = 0; i < _spWeightList.length; i++) {
      if (firstTime) {
        //turn off bool
        firstTime = false;
        //save off the items
        holdId = _spWeightList[i].id;
        holdDate = _spWeightList[i].date;
        holdWeight = _spWeightList[i].weight;
        holdWeightDiff = 0.0;
      } else {
        //all the records after the first
        //calc the weightDiff
        holdWeightDiff = holdWeight - _spWeightList[i].weight;
        //create object and write to list
        _finalWeightList.add(WeightClass(
            id: holdId,
            date: holdDate,
            weight: holdWeight,
            weightDiff: holdWeightDiff));
        //save off the current records
        holdId = _spWeightList[i].id;
        holdDate = _spWeightList[i].date;
        holdWeight = _spWeightList[i].weight;
        holdWeightDiff = 0.0;
      }
      if (i == (_spWeightList.length - 1)) {
        //this is the last record and needs to be written.  The above
        //process is always writing the prev record after the calculation
        _finalWeightList.add(WeightClass(
            id: holdId,
            date: holdDate,
            weight: holdWeight,
            weightDiff: holdWeightDiff));
      }
    }

    return _finalWeightList;
    //return _spWeightList;
  }

  static Future<bool> setWeightList(List<WeightClass> _theWeightList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> spList =
        _theWeightList.map((item) => json.encode(item.toMap())).toList();
    return prefs.setStringList(_weightListKey, spList);
  }
}
