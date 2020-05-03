import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:medicine/model/reminder.dart';

class EditReminder extends StatefulWidget {
  static String routeName = "/editReminder";

  @override
  _EditReminderState createState() => _EditReminderState();
}

class _EditReminderState extends State<EditReminder> {
  TextEditingController _labelController = TextEditingController();

  TextEditingController _pillsController = TextEditingController();

  Reminder _reminder;

  @override
  Widget build(BuildContext context) {
    if (_reminder == null) {
      _reminder = ModalRoute.of(context).settings.arguments;
      _labelController.text = _reminder.label;
      _pillsController.text = _reminder.pills.toString();
    }

    return Scaffold(
      body: Hero(
        tag: _reminder.id,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _labelController,
                  ),
                  TextField(
                    controller: _pillsController,
                    keyboardType: TextInputType.number,
                  ),
                  InkWell(
                    onTap: () => _pickDateTime(context),
                    child: Text(
                      _reminder.timeOfDay.format(context),
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      padding: EdgeInsets.all(8.0),
                      icon: Icon(Icons.check),
                      onPressed: () => _validate(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validate(context) {
    _reminder.label = _labelController.text;
    _reminder.pills = int.parse(_pillsController.text);
    Navigator.of(context).pop(_reminder);
  }

  Future<void> _pickDateTime(BuildContext context) async {
    DatePicker.showTimePicker(
      context,
      showSecondsColumn: false,
      currentTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        _reminder.timeOfDay.hour,
        _reminder.timeOfDay.minute,
      ),
      onConfirm: (date) {
        setState(() {
          _reminder.timeOfDay = TimeOfDay(hour: date.hour, minute: date.minute);
        });
      },
    );
  }
}
