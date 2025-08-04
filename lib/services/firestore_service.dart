import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather_app/models/search_history_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add search to history
  Future<void> addSearchHistory(String userId, String cityName) async {
    await _firestore.collection('searches').add({
      'userId': userId,
      'cityName': cityName,
      'timestamp': Timestamp.now(),
    });
  }

  // Get user's search history
  Stream<List<SearchHistory>> getSearchHistory(String userId) {
    return _firestore
        .collection('searches')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SearchHistory.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  // Delete search from history
  Future<void> deleteSearchHistory(String id) async {
    await _firestore.collection('searches').doc(id).delete();
  }
}
