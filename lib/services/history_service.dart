import 'package:medicine/model/took.dart';

class HistoryService {
  List<Took> tooks = List();

  add(Took took) {
    tooks.add(took);
  }
}
