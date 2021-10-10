import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/food_class.dart';

class NewFood extends StatefulWidget {
  final Function addFood;
  final List<FoodClass> userFoodList;

  NewFood(this.addFood, this.userFoodList);

  @override
  _NewFoodState createState() => _NewFoodState();
}

class _NewFoodState extends State<NewFood> {
  final foodController = TextEditingController();
  final calController = TextEditingController();
  var textEditingValue = TextEditingValue();

  void submitData() {
    if (foodController.text.isEmpty) return;
    final enteredFood = foodController.text;

    if (calController.text.isEmpty) return;
    if (int.tryParse(calController.text) == null) return;
    if (int.parse(calController.text) < 0) return;
    final enteredCal = int.tryParse(calController.text);

    widget.addFood(enteredFood, enteredCal);
    Navigator.of(context).pop();
  }

  Future<List<FoodClass>> getSuggestions(String query) async {
    return widget.userFoodList
        .where((FoodClass foodClass) =>
            foodClass.foodItem.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    foodController.dispose();
    calController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 10,
              ),
              Autocomplete<FoodClass>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<FoodClass>.empty();
                  }

                  return widget.userFoodList
                      .where((FoodClass foodClass) => foodClass.foodItem
                          .toLowerCase()
                          //.startsWith(textEditingValue.text.toLowerCase()))
                          .contains(textEditingValue.text.toLowerCase()))
                      .toList();
                },
                onSelected: (FoodClass selection) {
                  //print('Selected: ${selection.foodItem} : ${selection.calories}');
                  foodController.text = selection.foodItem;
                  calController.text = selection.calories.toString();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'food',
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                ],
              ),
              const Divider(
                height: 5,
                thickness: 4,
                color: Colors.amber,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'enter food'),
                controller: foodController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'enter calories'),
                controller: calController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                onSubmitted: (_) => submitData(),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  child: Text('cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('save'),
                  onPressed: submitData,
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
