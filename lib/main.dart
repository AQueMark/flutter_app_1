import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app_1/screens/reflect_screen.dart';
import 'package:flutter_app_1/screens/calendar_screen.dart';
import 'package:flutter_app_1/screens/lessons_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Inter',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  DateTime? _dateForReflectScreen;

  final GlobalKey<LessonsScreenState> _lessonsScreenKey = GlobalKey<LessonsScreenState>();
  final GlobalKey<CalendarScreenState> _calendarScreenKey = GlobalKey<CalendarScreenState>();

  // This is the new function that ReflectScreen will call after saving
  void navigateToLessonsAndRefresh() {
    setState(() {
      _selectedIndex = 0; // Switch to the Lessons tab
    });
    _lessonsScreenKey.currentState?.refreshLessons();
    _calendarScreenKey.currentState?.refreshCalendar();
  }

  // This is the new function that ReflectScreen will call after deleting
  void navigateToCalendarAndRefresh() {
    setState(() {
      _selectedIndex = 2; // Switch to the Calendar tab
    });
    _lessonsScreenKey.currentState?.refreshLessons();
    _calendarScreenKey.currentState?.refreshCalendar();
  }
  
  // This function is for the Calendar screen to open the Reflect screen
  void navigateToReflectWithDate(DateTime date) {
    setState(() {
      _dateForReflectScreen = date;
      _selectedIndex = 1;
    });
  }

  void _onItemTapped(int index) {
    // When leaving the Reflect screen, refresh the others
    if (_selectedIndex == 1 && index != 1) {
       _lessonsScreenKey.currentState?.refreshLessons();
       _calendarScreenKey.currentState?.refreshCalendar();
    }
    // When tapping the '+' tab, clear any date from the calendar
    if (index == 1) {
      _dateForReflectScreen = null;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screenWidgets = [
      LessonsScreen(key: _lessonsScreenKey),
      ReflectScreen(date: _dateForReflectScreen),
      CalendarScreen(key: _calendarScreenKey),
    ];

    return Scaffold(
      // This is the fix. It stops the screen from resizing for the keyboard.
      resizeToAvoidBottomInset: false,
      body: screenWidgets[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1E1E1E).withOpacity(0.98),
        height: 80,
        elevation: 0,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () => _onItemTapped(0),
              icon: SvgPicture.asset(
                _selectedIndex == 0 ? 'assets/icons/book_icon_white.svg' : 'assets/icons/book_icon_grey.svg',
                width: 32,
                height: 32,
              ),
            ),
            const SizedBox(width: 60),
            IconButton(
              onPressed: () => _onItemTapped(2),
              icon: SvgPicture.asset(
                _selectedIndex == 2 ? 'assets/icons/calendar_icon_white.svg' : 'assets/icons/calendar_icon_grey.svg',
                width: 32,
                height: 32,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 40),
        child: GestureDetector(
          onTap: () => _onItemTapped(1),
          child: Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: Color(0xFF282828),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                _selectedIndex == 1 ? 'assets/icons/add_icon_white.svg' : 'assets/icons/add_icon_grey.svg',
                width: 43,
                height: 43,
              ),
            ),
          ),
        ),
      ),
    );
  }
}