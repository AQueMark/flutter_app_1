import 'package:flutter/material.dart';
import 'package:flutter_app_1/screens/calendar_screen.dart';
import 'package:flutter_app_1/screens/lessons_screen.dart';
import 'package:flutter_app_1/screens/reflect_screen.dart';
import 'package:flutter_app_1/utils/database_helper.dart';
import 'package:flutter_app_1/widgets/custom_bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Inter',
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Start on Reflect screen
  DateTime? _dateForReflectScreen;

  late Future<List<Lesson>> _allLessonsFuture;
  List<Lesson> _allLessons = [];

  @override
  void initState() {
    super.initState();
    _allLessonsFuture = _fetchAndCacheLessons();
  }

  Future<List<Lesson>> _fetchAndCacheLessons() async {
    final lessons = await DatabaseHelper.instance.getAllLessons();
    if (mounted) {
      setState(() {
        _allLessons = lessons;
      });
    }
    return lessons;
  }
  
  void refreshAllData() {
    setState(() {
      _allLessonsFuture = _fetchAndCacheLessons();
    });
  }
  
  void navigateToReflectWithDate(DateTime date) {
    setState(() {
      _dateForReflectScreen = date;
      _selectedIndex = 1;
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      _dateForReflectScreen = DateTime.now();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<List<Lesson>>(
        future: _allLessonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && _allLessons.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          
          final screenWidgets = [
            LessonsScreen(allLessons: _allLessons, onDataChanged: refreshAllData),
            ReflectScreen(
              key: ValueKey(_dateForReflectScreen),
              date: _dateForReflectScreen ?? DateTime.now(),
              allLessons: _allLessons,
              onDataChanged: refreshAllData,
              isOpenedFromLessons: false,
            ),
            CalendarScreen(
              allLessons: _allLessons,
              onNavigateToReflect: navigateToReflectWithDate,
            ),
          ];

          return screenWidgets[_selectedIndex];
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ReflectFloatingActionButton(
        selectedIndex: _selectedIndex,
        onPressed: () => _onItemTapped(1),
      ),
    );
  }
}