import 'dart:convert';

import 'package:flutter/material.dart';

class Reminder {
  int id;
  int pills = 0;
  String label;
  TimeOfDay timeOfDay;

  Reminder(this.id, {this.pills, this.label, this.timeOfDay});

  get hour => timeOfDay.hour;

  get minute => timeOfDay.minute;

  Reminder.fromJson(String jsonString) {
    var json = jsonDecode(jsonString);
    id = json['id'];
    pills = json['pills'];
    label = json['label'];
    timeOfDay = TimeOfDay(hour: json['hour'], minute: json['minute']);
  }

  String toJson() => jsonEncode({
        'id': id,
        'pills': pills,
        'label': label,
        'hour': hour,
        'minute': minute
      });
}
