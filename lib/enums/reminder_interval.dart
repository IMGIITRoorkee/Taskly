enum ReminderInterval {
  oneHour("Before 1hr", 1),
  fiveHour("Before 5hr", 5),
  oneDay("Before 1 day", 24),
  twoDay("Before 2 days", 48),
  oneWeek("Before 1 week", 168);

  const ReminderInterval(this.title, this.interval);
  final String title;
  final int interval;
}
