import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shop_provider/src/models/product.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('product');

class Database {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static Future<void> addItem({
    required Product product,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "imageURL": product.imageURL,
      "title": product.title,
      "description": product.description,
      "price": product.price,
      "currency": product.currency,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Product added to the DB"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    return _mainCollection.snapshots();
  }
  // TODO: Update Product implementation
  // static Future<void> updateItem({
  //   required String? docId,
  //   required String? content,
  //   required bool? isDone,
  // }) async {
  //   DateTime lastUpdated = DateTime.now();

  //   DocumentReference documentReferencer =
  //       _mainCollection.doc(userUid).collection('items').doc(docId);

  //   Map<String, dynamic> data = <String, dynamic>{
  //     "content": content,
  //     "last_updated": lastUpdated,
  //     "is_done": isDone,
  //   };

  //   await documentReferencer
  //       .update(data)
  //       .whenComplete(() => print("Task updated on the DB"))
  //       .catchError((e) => print(e));
  // }

  static Future<void> deleteItem({
    required String productId,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(productId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Product is deleted from DB'))
        .catchError((e) => print(e));
  }
}
