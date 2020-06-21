import 'package:flutter/material.dart';
import 'package:medicine/model/reminder.dart';

class ReminderWidget extends StatelessWidget {
  final Reminder reminder;
  final Function onTap;
  final Function onDelete;

  ReminderWidget({
    @required this.reminder,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: () => onTap(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildLine(reminder.label, "to take"),
            _buildLine(reminder.pills.toString(), "pill"),
            _buildLine(reminder.timeOfDay.format(context), "every day"),
          ],
        ),
      ),
    );
  }

  Widget _buildLine(String primaryText, secondaryText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          primaryText,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 32,
          ),
        ),
        Text(
          secondaryText,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
