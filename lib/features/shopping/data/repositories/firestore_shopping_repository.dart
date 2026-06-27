import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/shopping_item.dart';
import '../../domain/repositories/shopping_repository.dart';

class FirestoreShoppingRepository implements ShoppingRepository {
  final FirebaseFirestore _firestore;

  FirestoreShoppingRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('shopping');

  @override
  Future<void> addItem(ShoppingItem item) async {
    await _collection.add(item.toJson());
  }

  @override
  Future<void> updateItem(ShoppingItem item) async {
    await _collection.doc(item.name).set(item.toJson());
  }

  @override
  Future<void> removeItem(String itemId) async {
    await _collection.doc(itemId).delete();
  }

  @override
  Future<List<ShoppingItem>> loadItems() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => ShoppingItem.fromJson(doc.data())).toList();
  }
}
