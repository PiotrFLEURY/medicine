import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine/model/reminder.dart';
import 'package:medicine/model/took.dart';
import 'package:medicine/providers/history_provider.dart';
import 'package:provider/provider.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: HistoryProvider(),
      builder: (context, child) {
        return Consumer(
          builder: (context, HistoryProvider historyProvider, child) {
            return FutureBuilder(
              future: historyProvider.takenReminders(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Reminder> takendReminders = snapshot.data;
                  return ListView.builder(
                    itemCount: historyProvider.tooks.length,
                    itemBuilder: (context, index) {
                      Took took = historyProvider.tooks[index];
                      Reminder concernedReminder = takendReminders
                          .firstWhere((element) => element.id == took.id);
                      return Container(
                        color: Colors.blueGrey[700],
                        child: ListTile(
                          leading: Icon(
                            Icons.history,
                            color: Colors.blueGrey[200],
                          ),
                          title: Text(
                            concernedReminder.label,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            took.time.toIso8601String(),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return Container();
              },
            );
          },
        );
      },
    );
  }
}
