import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicine/model/reminder.dart';
import 'package:medicine/pages/edit_reminder.dart';
import 'package:medicine/services/notification_service.dart';

void main() {
  setup();
  runApp(MyApp());
}

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<NotificationService>(NotificationService());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getIt.get<NotificationService>().init(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      initialRoute: MainPage.routeName,
      routes: {
        MainPage.routeName: (context) => MainPage(),
        EditReminder.routeName: (context) => EditReminder(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  static String routeName = '/';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Reminder> _reminders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    height: 96.0,
                  ),
                ),
                Text(
                  "Medicine reminder",
                  style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today,
                        color: Colors.blueGrey,
                      ),
                      Text(
                        "Scheduled",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.blueGrey,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _addReminder(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(_reminders.length, (index) {
                      return _buildTile(_reminders[index]);
                    }),
                  ),
                ),
                Text(
                  "History",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text("TODO"),
                ),
              ],
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildTile(Reminder reminder) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Dismissible(
        key: Key(reminder.toString()),
        direction: DismissDirection.up,
        confirmDismiss: (direction) => _confirmDismiss(context),
        onDismissed: (direction) => _deleteReminder(reminder),
        child: Hero(
          tag: reminder.id,
          child: Container(
            height: 200,
            width: 200,
            child: Material(
              elevation: 8.0,
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: () => _editReminder(reminder),
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      height: 48.0,
                      width: 48.0,
                      child: Icon(
                        Icons.edit,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Text(
                    reminder.pills.toString(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    reminder.label,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(reminder.timeOfDay.format(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editReminder(Reminder reminder) async {
    Navigator.pushNamed(
      context,
      EditReminder.routeName,
      arguments: reminder,
    );
  }

  void _deleteReminder(Reminder reminder) async {
    setState(() {
      _reminders.remove(reminder);
    });
  }

  Future<bool> _confirmDismiss(context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Are you sure ?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('yes'),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('no'),
          ),
        ],
      ),
    );
  }

  Future<void> _addReminder(BuildContext context) async {
    print('add');
    var result = await Navigator.pushNamed(
      context,
      EditReminder.routeName,
      arguments: new Reminder(
        _uniqueId(),
        label: "",
        pills: 0,
        timeOfDay: new TimeOfDay(hour: 0, minute: 00),
      ),
    );
    if (result != null) {
      Reminder newReminder = result;
      GetIt.instance.get<NotificationService>().scheduleDailyNotifications(
            newReminder.id,
            "Reminder",
            "Don't forget to take your ${newReminder.label}",
            newReminder.timeOfDay,
          );
      setState(() {
        _reminders.add(newReminder);
      });
    }
  }

  int _uniqueId() {
    int maxId = _reminders.isEmpty
        ? 1
        : _reminders
            .map((it) => it.id)
            .toList()
            .reduce((current, next) => current > next ? current : next);
    return maxId + 1;
  }
}
