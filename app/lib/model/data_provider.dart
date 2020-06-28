enum WeightUnit { G, KG, LBS }
WeightUnit parseWeightUnit(String wu) {
  switch (wu) {
    case 'G':
      return WeightUnit.G;
    case 'KG':
      return WeightUnit.KG;
    case 'LBS':
      return WeightUnit.LBS;
    default:
      return null;
  }
}

String weightUnitToStr(WeightUnit wu) {
  switch (wu) {
    case WeightUnit.G:
      return 'G';
    case WeightUnit.KG:
      return 'KG';
    case WeightUnit.LBS:
      return 'LBS';
    default:
      return null;
  }
}

enum RecType { User, Manufacturer, Product, ReceiptEntry, Receipt, Meal }

abstract class OrmRecord {
  OrmRecord.fromMap(Map snapshot);
  Map<String, dynamic> toMap();
  String id;
}

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

double toDouble(dynamic i) {
  String _i = i.toString();
  return double.tryParse(_i) ?? 0.0;
}

String strNumFromDouble(double n, [int digits = 0]) {
  double _n = n ?? 0;
  _n = _n.isNaN ? 0 : _n;
  return _n.toStringAsFixed(digits);
}

List<String> mealNums = [
  '1. BREAKFAST',
  '2. BRUNCH',
  '3. LUNCH',
  '4. DINNER',
  '5. SUPPER'
];

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

class JsonMeal {
  JsonMeal();
  String date;
  String week;
  String meal;
  String product;
  String m;
  String p;
  String f;
  String c;
  String fbr;
  String sgr;
  String k;
  String pg;
  String fg;
  String cg;
  String fbrg;
  String sgrg;
  String kkal;
  static fromJson(dynamic val) {
    JsonMeal M = new JsonMeal();
    M.date = val['date'];
    M.week = val['week'];
    M.meal = val['meal'];
    M.product = val['product'];
    M.m = val['M'];
    M.p = val['P'];
    M.f = val['F'];
    M.c = val['C'];
    M.fbr = val['FBR'];
    M.sgr = val['SGR'];
    M.k = val['K'];
    M.pg = val['Pg'];
    M.fg = val['Fg'];
    M.cg = val['Cg'];
    M.fbrg = val['FBRg'];
    M.sgrg = val['SGRg'];
    M.kkal = val['Kcal'];
    return M;
  }
}
