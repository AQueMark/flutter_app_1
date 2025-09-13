import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  final String? id; // Firestore uses string IDs
  final String userId;
  final String incident;
  final String lesson;
  final DateTime date;

  Lesson({
    this.id,
    required this.userId,
    required this.incident,
    required this.lesson,
    required this.date,
  });

  // Helper method to convert a Lesson object to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'incident': incident,
      'lesson': lesson,
      'date': Timestamp.fromDate(date), // Convert DateTime to Firestore Timestamp
    };
  }

  // Factory constructor to create a Lesson object from a Firestore document
  factory Lesson.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Lesson(
      id: doc.id,
      userId: data['userId'] ?? '',
      incident: data['incident'] ?? '',
      lesson: data['lesson'] ?? '',
      // Convert Firestore Timestamp back to DateTime
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}