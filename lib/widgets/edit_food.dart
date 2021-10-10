import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditFood extends StatefulWidget {
  final Function editFood;
  final Function deleteFood;
  final String aId;
  final String afood;
  final String acal;

  EditFood(this.editFood, this.deleteFood, this.aId, this.afood, this.acal);

  @override
  _EditFoodState createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  final foodController = TextEditingController();
  final calController = TextEditingController();

  void submitData() {
    if (foodController.text.isEmpty) return;
    final enteredFood = foodController.text;

    if (calController.text.isEmpty) return;
    if (int.tryParse(calController.text) == null) return;
    if (int.parse(calController.text) < 0) return;
    final enteredCal = int.tryParse(calController.text);

    widget.editFood(widget.aId, enteredFood, enteredCal);
    Navigator.of(context).pop();
  }

  void deleteData() {
    widget.deleteFood(widget.aId);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    foodController.text = widget.afood;
    calController.text = widget.acal;
    super.initState();
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
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'food'),
                controller: foodController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'calories'),
                controller: calController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                onSubmitted: (_) => submitData(),
                //onChanged: ,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextButton(
                      child: const Text('delete'),
                      onPressed: deleteData,
                    ),
                  ),
                  TextButton(
                    child: const Text('cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text('update'),
                    onPressed: submitData,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
