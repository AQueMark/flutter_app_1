import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// The main() function is the starting point for all Flutter apps.
void main() {
  runApp(const MyApp());
}

// MyApp is the root widget of your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp is the main container for the app, where we define themes and navigation.
    return MaterialApp(
      debugShowCheckedModeBanner: false, // This removes the little "debug" banner
      
      // Here we define the dark theme we designed.
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Off-Black
        fontFamily: 'sans-serif',
        
        // Define the style for the bar at the top of each screen
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFEAEAEA), // Off-White
          ),
        ),
        
        // Define the style for the navigation bar at the bottom
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0x381E1E1E),     // Dark Grey for the nav bar
        ),
      ),
      
      // The 'home' is the first screen that appears when the app launches.
      home: const MainScreen(),
    );
  }
}

// This will be the main screen that holds our three tabs.
// We make it a StatefulWidget because we need to keep track of which tab is currently selected.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Index 0 is Lessons, Index 1 is Calendar

  final List<Widget> _screenWidgets = [
    Scaffold(
      appBar: AppBar(title: const Text('LESSONS')),
      body: const Center(
        child: Text('Lessons Screen Content', style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    ),
    Scaffold(
      appBar: AppBar(title: const Text('CALENDAR')),
      body: const Center(
        child: Text('Calendar Screen Content', style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    ),
  ];

  void _onItemTapped(int visualIndex) {
    if (visualIndex == 1) {
      // TODO: Navigate to the ReflectScreen here later
      print('Central Add button tapped!');
    } else {
      setState(() {
        _selectedIndex = (visualIndex == 0) ? 0 : 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenWidgets[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        // ignore: deprecated_member_use
        color: const Color(0xAB1E1E1E),
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
                // **FIX #2: Increased icon size for balance**
                width: 32,
                height: 32,
              ),
            ),
            const SizedBox(width: 60),
            IconButton(
              onPressed: () => _onItemTapped(2),
              icon: SvgPicture.asset(
                _selectedIndex == 1 ? 'assets/icons/calendar_icon_white.svg' : 'assets/icons/calendar_icon_grey.svg',
                // **FIX #2: Increased icon size for balance**
                width: 32,
                height: 32,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Transform.translate(
        // **FIX #1: Reduced the offset to lift the button**
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
                'assets/icons/add_icon_grey.svg',
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