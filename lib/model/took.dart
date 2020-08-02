class Took {
  int _reminderId;
  DateTime _dateTime;

  Took(this._reminderId, this._dateTime);

  get id => _reminderId;
  DateTime get time => _dateTime;
}
