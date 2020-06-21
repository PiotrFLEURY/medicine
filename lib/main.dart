import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicine/model/reminder.dart';
import 'package:medicine/pages/edit_reminder.dart';
import 'package:medicine/services/notification_service.dart';
import 'package:medicine/services/setup/services_setup.dart';
import 'package:medicine/widgets/reminder_widget.dart';

void main() {
  setupServices();
  runApp(MyApp());
}

final getIt = GetIt.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getIt.get<NotificationService>().init(context);
    return MaterialApp(
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
  int _currentPage = 0;

  NotificationService notificationService = getIt.get<NotificationService>();

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initReminder();
  }

  Future<void> _initReminder() async {
    List<PendingNotificationRequest> pendingRequests =
        await notificationService.getPending();

    List<Reminder> reminders = pendingRequests != null
        ? pendingRequests.map((e) => Reminder.fromJson(e.payload)).toList()
        : List();
    setState(() {
      _reminders = reminders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 12,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 56.0,
                        maxWidth: double.infinity,
                      ),
                      child: Row(
                        children: List.generate(
                          _reminders.length,
                          (index) {
                            var reminder = _reminders[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _currentPage = index;
                                  _pageController.animateToPage(_currentPage,
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.decelerate);
                                });
                              },
                              child: Container(
                                height: double.infinity,
                                width: 100,
                                padding: EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  reminder.label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: _currentPage == index
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 56.0,
                    width: 56.0,
                    color: Colors.grey[100],
                    child: IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.grey,
                      onPressed: () => _addReminder(context),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.grey[200],
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Scheduled notifications",
                    style: TextStyle(
                      color: Colors.black.withAlpha(150),
                    ),
                  ),
                  Icon(
                    Icons.schedule,
                    color: Colors.blue,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Stack(
                children: <Widget>[
                  _buildEmptyScreen(),
                  PageView(
                    controller: _pageController,
                    children: List.generate(_reminders.length, (index) {
                      var reminder = _reminders[index];
                      return ReminderWidget(
                        reminder: reminder,
                        onTap: () => _editReminder(reminder),
                        onDelete: () => _deleteReminder(reminder),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Center _buildEmptyScreen() {
    return Center(
      child: Text(
        _reminders.length == 0 ? "Press + button to add" : "",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 18,
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
      if ((result as Reminder).deleted) {
        _deleteReminder(result);
      } else {
        notificationService.replaceSchedule(result);
        setState(() {
          _reminders.remove(reminder);
          _reminders.add(result);
        });
      }
    }
  }

  void _deleteReminder(Reminder reminder) async {
    setState(() {
      _reminders.remove(reminder);
      notificationService.cancel(reminder);
    });
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
