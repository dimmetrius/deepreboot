int getDateStartTs(DateTime d) {
  DateTime startDt = DateTime(d.year, d.month, d.day);
  return startDt.millisecondsSinceEpoch;
}

int getDateEndTs(DateTime d) {
  DateTime startDt = DateTime(d.year, d.month, d.day);
  DateTime endDt = startDt.add(Duration(days: 1));
  return endDt.millisecondsSinceEpoch - 1;
}
