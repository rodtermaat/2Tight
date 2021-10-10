import 'package:flutter/foundation.dart';

class WeightClass {
  final String id;
  final DateTime date;
  final double weight;
  double weightDiff;

  WeightClass({
    @required this.id,
    @required this.date,
    @required this.weight,
    this.weightDiff = 0.0,
  });

  @override
  String toString() {
    return '$date ($weight)';
  }

  WeightClass.fromMap(Map map)
      : this.id = map['id'],
        this.date = DateTime.parse(map['date']),
        this.weight = map['weight'];

  Map toMap() {
    return {
      'id': this.id,
      'date': this.date.toIso8601String(),
      'weight': this.weight
    };
  }
}
