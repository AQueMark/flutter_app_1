import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_1/auth/auth_gate.dart';
import 'package:flutter_app_1/screens/calendar_screen.dart';
import 'package:flutter_app_1/screens/lessons_screen.dart';
import 'package:flutter_app_1/screens/reflect_screen.dart';
import 'package:flutter_app_1/services/firestore_service.dart';
import 'package:flutter_app_1/utils/database_helper.dart';
import 'package:flutter_app_1/widgets/custom_bottom_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_1/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        fontFamily: 'K2D',
      ),
      home: const AuthGate(),
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
  int _selectedIndex = 1;
  DateTime? _dateForReflectScreen;

  final FirestoreService _firestoreService = FirestoreService();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  late Future<List<Lesson>> _allLessonsFuture;
  List<Lesson> _allLessons = [];

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      _allLessonsFuture = _fetchAndCacheLessons();
    }
  }

  Future<List<Lesson>> _fetchAndCacheLessons() async {
    if (currentUser == null) return [];
    final lessons = await _firestoreService.getAllLessons(currentUser!);
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
            LessonsScreen(
                allLessons: _allLessons, 
                onDataChanged: refreshAllData,
                currentUser: currentUser,
                firestoreService: _firestoreService,
            ),
            ReflectScreen(
              key: ValueKey(_dateForReflectScreen),
              date: _dateForReflectScreen ?? DateTime.now(),
              allLessons: _allLessons,
              onDataChanged: refreshAllData,
              isOpenedFromLessons: false,
              currentUser: currentUser,
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