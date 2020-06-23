import 'package:app/model/data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsModel extends ChangeNotifier {
  final Firestore _db = Firestore.instance;
  List<Product> products = new List<Product>();
  
}