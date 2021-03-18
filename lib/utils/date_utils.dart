bool isToday(DateTime date) {
  final now = DateTime.now();
  return isTheSameDay(now, date);
}

bool isTheSameDay(DateTime d1, DateTime d2) {
  return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
}
