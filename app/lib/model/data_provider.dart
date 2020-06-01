import 'dart:convert';

import 'package:flutter/material.dart';

enum WeightUnit { G }

class User {
  String id;
}

class Product {
  Product({this.id, this.name});
  String id;
  String name;
  /*
  id: String!
  manufacturer: Manufacturer
  kkal: double
  protein: double
  fat: double
  carb: double
  receipt: Receipt
  creator: User
  */
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
  static fromJson(dynamic val){
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

class Meal {
  Meal(
      {this.id,
      this.time,
      this.product,
      this.weight,
      this.weigthUnit = WeightUnit.G,
      this.user});
  String id;
  DateTime time;
  Product product;
  double weight;
  WeightUnit weigthUnit;
  User user;
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
