import 'package:app/core/orm_record.dart';

class User implements OrmRecord {
  String id;
  String phone;
  User.fromMap(Map snapshot) {
    id = snapshot['id'] ?? '';
    phone = snapshot['phone'] ?? '';
  }
  Map<String, dynamic> toMap() {
    return {"id": id, "phone": phone};
  }
}
