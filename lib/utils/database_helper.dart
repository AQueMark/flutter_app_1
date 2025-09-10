import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class Lesson {
  // We no longer need a separate 'id' because the date is our unique identifier
  final String incident;
  final String lesson;
  final DateTime date;

  Lesson({
    required this.incident,
    required this.lesson,
    required this.date,
  });

  // This function converts our Lesson object into a Map for saving
  Map<String, dynamic> toMap() {
    return {
      // We format the date as 'YYYY-MM-DD' to make it a unique key for each day
      'date': DateFormat('yyyy-MM-dd').format(date),
      'incident': incident,
      'lesson': lesson,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'lessons.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }
  // Function to get all lessons for a specific day
  Future<List<Lesson>> getLessonsForDay(DateTime date) async {
    Database db = await instance.database;
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final List<Map<String, dynamic>> maps = await db.query(
      'lessons',
      where: 'date = ?',
      whereArgs: [formattedDate],
    );

    return List.generate(maps.length, (i) {
      return Lesson(
        incident: maps[i]['incident'],
        lesson: maps[i]['lesson'],
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }

  // This is called when the database is first created
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE lessons (
        date TEXT PRIMARY KEY, -- The date is now the unique Primary Key
        incident TEXT NOT NULL,
        lesson TEXT NOT NULL
      )
      ''');
  }

  // --- CRUD Operations ---

  // This function now UPDATES an existing entry or INSERTS a new one
  Future<int> upsert(Lesson lesson) async {
    Database db = await instance.database;
    return await db.insert(
      'lessons',
      lesson.toMap(),
      // This is the key change: if a lesson for that date already exists,
      // it will be replaced with the new one.
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // --- CRUD Operations ---

  // ... (your existing upsert and getAllLessons functions)

  // This function deletes a lesson from the database based on its date
  Future<int> delete(DateTime date) async {
    Database db = await instance.database;
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return await db.delete(
      'lessons',
      where: 'date = ?',
      whereArgs: [formattedDate],
    );
  }

  // Function to get all lessons from the database
  Future<List<Lesson>> getAllLessons() async {
    Database db = await instance.database;
    // Order by date descending to show the newest lessons first
    final List<Map<String, dynamic>> maps = await db.query('lessons', orderBy: 'date DESC');

    return List.generate(maps.length, (i) {
      return Lesson(
        incident: maps[i]['incident'],
        lesson: maps[i]['lesson'],
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }
}