import 'package:flutter/material.dart';

class JustTheFacts extends StatelessWidget {
  final double currentWeight;
  final double lostSoFar;
  final double poundsToLose;

  JustTheFacts(this.currentWeight, this.lostSoFar, this.poundsToLose);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              CircleAvatar(
                radius: 25,
                child: Text(currentWeight.toStringAsFixed(1)),
              ),
              Center(
                child: const Text('..current weight'),
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
                child: Text(lostSoFar.toStringAsFixed(2)),
              ),
              Center(
                child: const Text('..lost so far'),
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
                    child: Text(poundsToLose.toStringAsFixed(2)),
                  ),
                  Center(
                    child: const Text('..to lose'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
