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
                  Text('Edit your reminder'),
                  TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.label),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    controller: _labelController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.mode_edit),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    controller: _pillsController,
                    keyboardType: TextInputType.number,
                  ),
                  Container(
                    width: double.infinity,
                    height: 64.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        style: BorderStyle.solid,
                        color: Colors.grey,
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _pickDateTime(context),
                      borderRadius: BorderRadius.circular(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _reminder.timeOfDay.format(context),
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Icon(
                              Icons.access_time,
                              color: Colors.grey,
                            ),
                          ],
                        ),
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
