import 'package:flutter/material.dart';

class Reminder {
  int _id;
  int pills = 0;
  String label;
  TimeOfDay timeOfDay;

  Reminder(this._id, {this.pills, this.label, this.timeOfDay});

  get id => _id;
}
