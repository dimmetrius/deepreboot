import 'dart:async';

import 'package:app/model/auth_model.dart';
import 'package:app/model/data_provider.dart';
import 'package:app/service/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class QueryFilter {
  String name;
  Query apply(Query query);
}

class WhereFilter extends QueryFilter {
  String name;
  dynamic field;
  dynamic isEqualTo;
  dynamic isLessThan;
  dynamic isLessThanOrEqualTo;
  dynamic isGreaterThan;
  dynamic isGreaterThanOrEqualTo;
  dynamic arrayContains;
  List<dynamic> arrayContainsAny;
  List<dynamic> whereIn;
  bool isNull;

  WhereFilter(
    this.name,
    this.field, {
    this.isEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.isNull,
  });

  Query apply(Query input) {
    if (field == null) {
      return input;
    }
    if (isEqualTo != null) {
      return input.where(field, isEqualTo: isEqualTo);
    }
    if (isGreaterThan != null) {
      return input.where(field, isGreaterThan: isGreaterThan);
    }
    if (isLessThan != null) {
      return input.where(field, isLessThan: isLessThan);
    }
    if (isGreaterThanOrEqualTo != null) {
      return input.where(field, isGreaterThanOrEqualTo: isGreaterThanOrEqualTo);
    }
    if (isLessThanOrEqualTo != null) {
      return input.where(field, isLessThanOrEqualTo: isLessThanOrEqualTo);
    }
    return input;
  }
}

class CollectionModel<T extends OrmRecord> extends ChangeNotifier {
  AuthModel authModel;
  Api api;
  Query query;
  List<QueryFilter> filters;
  String collectionName = '';
  StreamSubscription<QuerySnapshot> subscription;
  CollectionModel(AuthModel authModel) {
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
    api = Api(collectionName);
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

  setFilters(List<QueryFilter> filters) {
    this.filters = filters;
    fetch();
  }

  updateFilter(QueryFilter f){
    int nameIndex = this.filters.indexWhere((element) => element.name == f.name);
    if(nameIndex >= 0){
      this.filters[nameIndex] = f;
    }else{
      this.filters.add(f);
    }
  }

  QueryFilter getFilterByName(String name) {
    return filters?.firstWhere((element) {
      return name == element.name;
    }, orElse: () => null);
  }

  fetch() async {
    await subscription?.cancel();
    if (authModel.user == null) {
      records = [];
      subscription = null;
      notifyListeners();
    } else {
      query = api.ref.where('creatorID', isEqualTo: authModel.user.uid);
      filters?.forEach((filter) {
        query = filter.apply(query);
      });
      subscription = query.snapshots().listen((event) {
        records =
            event.documents.map((e) => _fromMap(e.data)).cast<T>().toList();
        print('records updated');
        notifyListeners();
      });
    }
  }

  Future remove(String id) async {
    await api.removeDocument(id);
    return;
  }

  Future update(OrmRecord data, String id) async {
    await api.updateDocument(data.toMap(), id);
    return;
  }

  Future addRecord(OrmRecord data) async {
    await api.addDocument(data.toMap());
    return;
  }

  Future addRecordWithId(OrmRecord data, String id) async {
    await api.addDocumentWithId(data.toMap(), id);
    return;
  }

  @override
  void dispose() {
    subscription.cancel();
    authModel.removeListener(fetch);
    super.dispose();
  }

  List<T> records = new List<T>();

  T findRecordById(String id) {
  T m = records.firstWhere((T element) {
    return element.id == id;
  }, orElse: () => null);
  return m;
}
}
