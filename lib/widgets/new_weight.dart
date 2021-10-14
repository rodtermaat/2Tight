//********************************************/
// Copyright 2021 Rod TerMaat (BigManSoftware)
// rodtermaat@gmail.com
// GNU General Public Lisense
//********************************************/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewWeight extends StatefulWidget {
  final Function addNewWeight;

  NewWeight(this.addNewWeight);

  @override
  _NewWeightState createState() => _NewWeightState();
}

class _NewWeightState extends State<NewWeight> {
  final weightController = TextEditingController();

  var textEditingValue = TextEditingValue();
  DateTime _selectedDate = DateTime.now();

  void submitData() {
    //print('NewWeight: submitData');
    if (weightController.text.isEmpty) return;
    if (double.tryParse(weightController.text) == null) return;
    if (double.parse(weightController.text) < 0) return;
    final double enteredWeight = double.tryParse(weightController.text);
    //print('NewWeight: addNewWeight');
    widget.addNewWeight(_selectedDate, enteredWeight);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  void dispose() {
    weightController.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        textStyle:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    child: const Text(
                      'Chose date',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _presentDatePicker,
                  ),
                  Text(
                    _selectedDate == null
                        ? DateFormat.yMd().format(_selectedDate)
                        : DateFormat.yMd().format(_selectedDate),
                  ),
                ],
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'todays weight'),
                controller: weightController,
                keyboardType: TextInputType.number,
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                // ],
                onSubmitted: (_) => submitData(),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  child: const Text('cancel'),
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
