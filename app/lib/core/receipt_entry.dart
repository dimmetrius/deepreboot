import 'package:app/core/orm_record.dart';

class ReceiptEntry implements OrmRecord {
  ReceiptEntry(
      {this.id,
      this.receiptID,
      this.productID,
      this.weight,
      this.kkal,
      this.protein,
      this.fat,
      this.carb,
      this.sugar,
      this.fibers,
      this.creatorID});
  ReceiptEntry.fromMap(Map snapshot) {
    id = snapshot["id"] ?? "";
    receiptID = snapshot["receiptID"] ?? "";
    productID = snapshot["productID"] ?? "";
    weight = snapshot["weight"] ?? 0;
    kkal = snapshot['kkal'] ?? 0;
    protein = snapshot['protein'] ?? 0;
    fat = snapshot['fat'] ?? 0;
    carb = snapshot['carb'] ?? 0;
    sugar = snapshot['sugar'] ?? 0;
    fibers = snapshot['fibers'] ?? 0;
    creatorID = snapshot["creatorID"] ?? "";
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "receiptID": receiptID,
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
  String receiptID;
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
