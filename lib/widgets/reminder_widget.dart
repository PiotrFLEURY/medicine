import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:medicine/model/reminder.dart';

class ReminderWidget extends StatefulWidget {
  final Reminder reminder;
  final Function onTap;
  final Function onTake;
  final Function onDelete;

  ReminderWidget({
    @required this.reminder,
    @required this.onTap,
    @required this.onTake,
    @required this.onDelete,
  });

  @override
  _ReminderWidgetState createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[800],
      child: ExpansionTile(
        backgroundColor: Colors.blueGrey[600],
        initiallyExpanded: _expanded,
        onExpansionChanged: (value) {
          setState(() {
            _expanded = value;
          });
          return true;
        },
        title: Text(
          widget.reminder.label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            widget.reminder.timeOfDay.format(context),
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        leading: Container(
          height: 48.0,
          width: 48.0,
          child: Center(
            child: Text(
              "x${widget.reminder.pills}",
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            ),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        children: <Widget>[
          Container(
            color: Colors.blueGrey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.check),
                FlatButton(
                  child: Text("Mark as done"),
                  onPressed: () => widget.onTake(),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.blueGrey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.edit),
                FlatButton(
                  child: Text("Edit"),
                  onPressed: () => widget.onTap(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
