import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  Api(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map<String, dynamic> data) {
    return ref.add(data);
  }

  Future<void> addDocumentWithId(Map<String, dynamic> data, id) {
    return ref.document(id).setData(data);
  }

  Future<void> updateDocument(Map<String, dynamic> data, String id) {
    return ref.document(id).updateData(data);
  }
}
