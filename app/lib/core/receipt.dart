import 'package:app/core/orm_record.dart';

class Receipt implements OrmRecord {
  Receipt(
      {this.id,
      this.name,
      this.description,
      this.kkal,
      this.protein,
      this.fat,
      this.carb,
      this.sugar,
      this.fibers,
      this.weight,
      this.creatorID});
  Receipt.fromMap(Map snapshot) {
    id = snapshot['id'] ?? "";
    name = snapshot["name"] ?? "";
    description = snapshot["description"] ?? "";
    kkal = snapshot['kkal'] ?? 0;
    protein = snapshot['protein'] ?? 0;
    fat = snapshot['fat'] ?? 0;
    carb = snapshot['carb'] ?? 0;
    sugar = snapshot['sugar'] ?? 0;
    fibers = snapshot['fibers'] ?? 0;
    creatorID = snapshot['creatorID'] ?? '';
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "kkal": kkal,
      "protein": protein,
      "fat": fat,
      "carb": carb,
      "sugar": sugar,
      "fibers": fibers,
      "creatorID": creatorID,
    };
  }

  String id;
  String name;
  String description;
  double kkal;
  double protein;
  double fat;
  double carb;
  double sugar;
  double fibers;
  double weight;
  String creatorID;
}
