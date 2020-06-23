import 'package:app/service/api.dart';
import 'package:app/model/data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDService {
  RecType recType;
  Api _api;

  CRUDService(RecType recType, String userID) {
    this.recType = recType;
    String collectionName = '';
    switch (recType) {
      case RecType.User:
        collectionName = 'user';
        break;
      case RecType.Manufacturer:
        collectionName = 'manufacturer';
        break;
      case RecType.Product:
        collectionName = 'product';
        break;
      case RecType.ReceiptEntry:
        collectionName = 'receiptentry';
        break;
      case RecType.Receipt:
        collectionName = 'receipt';
        break;
      case RecType.Meal:
        collectionName = 'meal';
        break;
      default:
        throw 'Unsupported';
    }
    this._api = new Api(collectionName, userID);
  }

  List<OrmRecord> records;

  OrmRecord _fromMap(Map snapshot) {
    switch (recType) {
      case RecType.User:
        return User.fromMap(snapshot);
      case RecType.Manufacturer:
        return Manufacturer.fromMap(snapshot);
      case RecType.Product:
        return Product.fromMap(snapshot);
      case RecType.ReceiptEntry:
        return ReceiptEntry.fromMap(snapshot);
      case RecType.Receipt:
        return Receipt.fromMap(snapshot);
      case RecType.Meal:
        return Meal.fromMap(snapshot);
      default:
        return null;
    }
  }

  Future<List<OrmRecord>> fetch() async {
    var result = await _api.getDataCollection();
    records = result.documents.map((doc) => _fromMap(doc.data)).toList();
    return records;
  }

  Stream<QuerySnapshot> fetchAsStream() {
    return _api.streamDataCollection();
  }

  Future<OrmRecord> getById(String id) async {
    var doc = await _api.getDocumentById(id);
    return _fromMap(doc.data);
  }

  Future remove(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future update(OrmRecord data, String id) async {
    await _api.updateDocument(data.toMap(), id);
    return;
  }

  Future addRecord(OrmRecord data) async {
    await _api.addDocument(data.toMap());
    return;
  }

  Future addRecordWithId(OrmRecord data, String id) async {
    await _api.addDocumentWithId(data.toMap(), id);
    return;
  }
}
