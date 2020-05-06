import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.telexTextTheme(),
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

  NotificationService notificationService = getIt.get<NotificationService>();

  @override
  void initState() {
    super.initState();
    _initReminder();
  }

  Future<void> _initReminder() async {
    List<PendingNotificationRequest> pendingRequests =
        await notificationService.getPending();

    List<Reminder> reminders =
        pendingRequests.map((e) => Reminder.fromJson(e.payload)).toList();
    setState(() {
      _reminders = reminders;
    });
  }

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
                  padding: const EdgeInsets.all(24.0),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    height: 96.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Medicine reminder",
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Scheduled",
                        style: TextStyle(
                          fontSize: 16,
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
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Text(
                          _reminders.length == 0 ? "Press + button to add" : "",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(_reminders.length, (index) {
                          return _buildTile(_reminders[index]);
                        }),
                      ),
                    ],
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
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              child: InkWell(
                onTap: () => _editReminder(reminder),
                borderRadius: BorderRadius.circular(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
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
      ),
    );
  }

  void _editReminder(Reminder reminder) async {
    var result = await Navigator.pushNamed(
      context,
      EditReminder.routeName,
      arguments: reminder,
    );
    if (result != null) {
      notificationService.replaceSchedule(result);
      setState(() {
        _reminders.remove(reminder);
        _reminders.add(result);
      });
    }
  }

  void _deleteReminder(Reminder reminder) async {
    setState(() {
      _reminders.remove(reminder);
      notificationService.cancel(reminder);
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
      notificationService.scheduleNotification(newReminder);
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
