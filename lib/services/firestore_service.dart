import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_1/utils/database_helper.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final CollectionReference _lessonsCollection;

  FirestoreService() {
    _lessonsCollection = _db.collection('lessons');
  }

  // --- MODIFIED: Now requires a user to fetch their lessons ---
  Future<List<Lesson>> getAllLessons(User user) async {
    final snapshot = await _lessonsCollection
        .where('userId', isEqualTo: user.uid) // Filter by the user's ID
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs.map((doc) => Lesson.fromFirestore(doc)).toList();
  }

  // --- MODIFIED: No longer uses date for the ID ---
  // Firestore can generate unique IDs automatically.
  Future<void> upsertLesson(Lesson lesson) {
    if (lesson.id != null) {
      // If the lesson has an ID, update the existing document
      return _lessonsCollection.doc(lesson.id).update(lesson.toJson());
    } else {
      // If it's a new lesson, add a new document
      return _lessonsCollection.add(lesson.toJson());
    }
  }

  // --- MODIFIED: Now requires the document ID to delete ---
  Future<void> deleteLesson(String lessonId) {
    return _lessonsCollection.doc(lessonId).delete();
  }
}