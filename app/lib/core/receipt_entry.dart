import 'package:app/core/orm_record.dart';

class ReceiptEntry implements OrmRecord {
  ReceiptEntry(
      {this.id, this.receiptID, this.productID, this.weight, this.creatorID});
  ReceiptEntry.fromMap(Map snapshot) {
    id = snapshot["id"] ?? "";
    receiptID = snapshot["receiptID"] ?? "";
    productID = snapshot["productID"] ?? "";
    weight = snapshot["weight"] ?? 0;
    creatorID = snapshot["creatorID"] ?? "";
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "receiptID": receiptID,
      "productID": productID,
      "weight": weight,
      "creatorID": creatorID,
    };
  }

  String id;
  String receiptID;
  String productID;
  double weight;
  String creatorID;
}
