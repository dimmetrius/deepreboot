import 'package:app/core/orm_record.dart';

class Meal implements OrmRecord {
  Meal(
      {this.id,
      this.name,
      this.time,
      this.num,
      this.productID,
      this.weight,
      this.kkal,
      this.protein,
      this.fat,
      this.carb,
      this.sugar,
      this.fibers,
      this.creatorID});
  Meal.fromMap(Map snapshot) {
    id = snapshot["id"];
    name = snapshot["name"] ?? "";
    time = snapshot["time"];
    num = snapshot["num"] ?? 0;
    productID = snapshot["productID"];
    weight = snapshot["weight"];
    kkal = snapshot['kkal'] ?? 0;
    protein = snapshot['protein'] ?? 0;
    fat = snapshot['fat'] ?? 0;
    carb = snapshot['carb'] ?? 0;
    sugar = snapshot['sugar'] ?? 0;
    fibers = snapshot['fibers'] ?? 0;
    creatorID = snapshot["creatorID"];
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "time": time,
      "name": name,
      "num": num,
      "productID": productID,
      "weight": weight,
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
  int time;
  String name;
  int num;
  String productID;
  double weight;
  double kkal;
  double protein;
  double fat;
  double carb;
  double sugar;
  double fibers;
  String creatorID;
}
