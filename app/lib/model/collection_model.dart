import 'package:app/model/auth_model.dart';
import 'package:app/model/data_provider.dart';
import 'package:app/service/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CollectionModel<T> extends ChangeNotifier {
  AuthModel authModel;
  Api api;
  Query query;
  String collectionName = '';
  CollectionModel(AuthModel authModel){
    this.authModel = authModel;
    switch (T) {
      case User:
        collectionName = 'user';
        break;
      case Manufacturer:
        collectionName = 'manufacturer';
        break;
      case Product:
        collectionName = 'product';
        break;
      case ReceiptEntry:
        collectionName = 'receiptentry';
        break;
      case Receipt:
        collectionName = 'receipt';
        break;
      case Meal:
        collectionName = 'meal';
        break;
      default:
        throw 'Unsupported';
    }
    authModel.addListener(fetch);
  }

    OrmRecord _fromMap(Map snapshot) {
    switch (T) {
      case User:
        return User.fromMap(snapshot);
      case Manufacturer:
        return Manufacturer.fromMap(snapshot);
      case Product:
        return Product.fromMap(snapshot);
      case ReceiptEntry:
        return ReceiptEntry.fromMap(snapshot);
      case Receipt:
        return Receipt.fromMap(snapshot);
      case Meal:
        return Meal.fromMap(snapshot);
      default:
        return null;
    }
  }

  fetch(){
    if(authModel.user == null){
      records = [];
      notifyListeners();
    }else{
      api = Api(collectionName);
      query = api.ref.where('creatorID', isEqualTo: authModel.user.uid);
      query.snapshots().listen((event) {
        records = event.documents.map((e) => _fromMap(e.data)).cast<T>().toList();
        notifyListeners();
      });
    }
  }
  @override
  void dispose() {
    authModel.removeListener(fetch);
    super.dispose();
  }
  
  List<T> records = new List<T>();
}