import 'package:app/core/orm_record.dart';

class Manufacturer implements OrmRecord {
  String id;
  String name;
  Manufacturer({this.id, this.name});
  Manufacturer.fromMap(Map snapshot) {
    id = snapshot['id'] ?? '';
    name = snapshot['name'] ?? '';
  }
  Map<String, dynamic> toMap() {
    return {"id": id, "name": name};
  }
}
