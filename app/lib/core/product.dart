import 'package:app/core/orm_record.dart';
import 'package:app/utils/double_utils.dart';

class Product implements OrmRecord {
  Product(
      {this.id,
      this.name,
      this.manufacturerID,
      this.kkal,
      this.protein,
      this.fat,
      this.carb,
      this.sugar,
      this.fibers,
      this.receiptID,
      this.creatorID});
  Product.fromMap(Map snapshot) {
    id = snapshot['id'] ?? '';
    name = snapshot['name'] ?? '';
    manufacturerID = snapshot['manufacturerID'] ?? '';
    kkal = toDouble(snapshot['kkal']);
    protein = toDouble(snapshot['protein']);
    fat = toDouble(snapshot['fat']);
    carb = toDouble(snapshot['carb']);
    sugar = toDouble(snapshot['sugar']);
    fibers = toDouble(snapshot['fibers']);
    receiptID = snapshot['receiptID'] ?? '';
    creatorID = snapshot['creatorID'] ?? '';
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "manufacturerID": manufacturerID,
      "kkal": kkal,
      "protein": protein,
      "fat": fat,
      "carb": carb,
      "sugar": sugar,
      "fibers": fibers,
      "receiptID": receiptID,
      "creatorID": creatorID,
    };
  }

  String id;
  String name;
  String manufacturerID;
  double kkal;
  double protein;
  double fat;
  double carb;
  double sugar;
  double fibers;
  String receiptID;
  String creatorID;
}
