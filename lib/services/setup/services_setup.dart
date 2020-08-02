import 'package:get_it/get_it.dart';
import 'package:medicine/services/history_service.dart';
import 'package:medicine/services/notification_service.dart';
import 'package:medicine/services/reminder_service.dart';

void setupServices() {
  GetIt.I.registerSingleton<NotificationService>(NotificationService());
  GetIt.I.registerSingleton<HistoryService>(HistoryService());
  GetIt.I.registerSingleton<ReminderService>(ReminderService());
}
