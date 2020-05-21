import 'package:get_it/get_it.dart';
import 'package:medicine/services/notification_service.dart';

void setupServices() {
  GetIt.instance.registerSingleton<NotificationService>(NotificationService());
}
