abstract class OrmRecord {
  OrmRecord.fromMap(Map snapshot);
  Map<String, dynamic> toMap();
  String id;
}
