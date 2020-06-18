import 'dart:convert';
import 'package:flutter/material.dart';

enum WeightUnit { G, KG, LBS }
enum RecType {User, Manufacturer, Product, ReceiptEntry, Receipt, Meal}
abstract class OrmRecord{
  OrmRecord.fromMap(Map snapshot);
  Map<String, dynamic> toMap();
}

class User implements OrmRecord{
  String id;
  String phone;
  User.fromMap(Map snapshot){
    id = snapshot['id'] ?? '';
    phone = snapshot['phone'] ?? '';
  }
  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "phone": phone 
    };
  }
}

class Manufacturer implements OrmRecord{
  String id;
  String name;
  Manufacturer({this.id, this.name});
  Manufacturer.fromMap(Map snapshot){
    id = snapshot['id'] ?? '';
    name = snapshot['name'] ?? '';
  }
  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "name": name 
    };
  }
}

class Product implements OrmRecord {
  Product({this.id, this.name, this.manufacturerID, this.kkal, this.protein, this.fat, this.carb, this.sugar, this.fibers, this.receiptID, this.creatorID});
  Product.fromMap(Map snapshot) {
    id = snapshot['id'] ?? '';
    name = snapshot['name'] ?? '';
    manufacturerID = snapshot['manufacturerID'] ?? '';
    kkal = snapshot['kkal'] ?? 0;
    protein = snapshot['protein'] ?? 0;
    fat = snapshot['fat'] ?? 0;
    carb = snapshot['carb'] ?? 0;
    sugar = snapshot['sugar'] ?? 0;
    fibers = snapshot['fibers'] ?? 0;
    receiptID = snapshot['receiptID'] ?? '';
    creatorID = snapshot['creatorID'] ?? '';
  }
  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "name" : name,
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

class ReceiptEntry implements OrmRecord{
  ReceiptEntry({this.id, this.receiptID, this.productID, this.weight, this.weightUnit = WeightUnit.G, this.creatorID});
  ReceiptEntry.fromMap(Map snapshot){
    id = snapshot["id"] ?? "";
    receiptID = snapshot["receiptID"] ?? "";
    productID = snapshot["productID"] ?? "";
    weight = snapshot["weight"] ?? 0;
    weightUnit = snapshot["weightUnit"] ?? WeightUnit.G;
    creatorID = snapshot["creatorID"] ?? "";
  }
  Map<String, dynamic> toMap(){
    return {
    "id": id,
    "receiptID": receiptID,
    "productID": productID,
    "weight": weight,
    "weightUnit": weightUnit,
    "creatorID": creatorID,
    };
  }
  String id;
  String receiptID;
  String productID;
  double weight;
  WeightUnit weightUnit;
  String creatorID;
}

class Receipt implements OrmRecord{
  Receipt({this.id, this.name, this.description, this.kkal, this.protein, this.fat, this.carb, this.sugar, this.fibers, this.weight, this.weightUnit, this.creatorID});
  Receipt.fromMap(Map snapshot){
    id = snapshot['id'] ?? "";
    name = snapshot["name"] ?? "";
    description = snapshot["description"] ?? "";
    kkal = snapshot['kkal'] ?? 0;
    protein = snapshot['protein'] ?? 0;
    fat = snapshot['fat'] ?? 0;
    carb = snapshot['carb'] ?? 0;
    sugar = snapshot['sugar'] ?? 0;
    fibers = snapshot['fibers'] ?? 0;
    weightUnit = snapshot['weightUnit'] ?? WeightUnit.G;
    creatorID = snapshot['creatorID'] ?? '';
  }
  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "name" : name,
      "description": description,
      "kkal": kkal,
      "protein": protein,
      "fat": fat,
      "carb": carb,
      "sugar": sugar,
      "fibers": fibers,
      "weightUnit": weightUnit,
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
  WeightUnit weightUnit;
  String creatorID;
}

class Meal implements OrmRecord{
  Meal({this.id, this.time, this.productID, this.weight, this.weightUnit, this.creatorID});
  Meal.fromMap(Map snapshot){
    id = snapshot["id"];
    time = snapshot["time"];
    productID = snapshot["productID"];
    weight = snapshot["weight"];
    weightUnit = snapshot["weightUnit"];
    creatorID = snapshot["creatorID"];
  }
  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "time": time,
      "productID": productID,
      "weightUnit": weightUnit,
      "creatorID": creatorID,
    };
  }
  String id;
  int time;
  String productID;
  double weight;
  WeightUnit weightUnit;
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

List<Product> products;
Product grecha = Product(id: 'id', name: 'Гречка');
List<JsonMeal> meals = [];

loadJson(BuildContext context) async {
  String data =
      await DefaultAssetBundle.of(context).loadString("res/food.json");
  List<dynamic> jsonResult = jsonDecode(data);
  jsonResult.forEach((dynamic element) {
    meals.add(JsonMeal.fromJson(element));
  });
}
