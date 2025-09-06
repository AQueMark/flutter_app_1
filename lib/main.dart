import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app_1/screens/reflect_screen.dart'; // Correctly imported

void main() {
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
        // Set a default font, but individual Text widgets can override this
        fontFamily: 'Inter', 
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // We now have 3 primary screens, so we manage the index from 0 to 2.
  int _selectedIndex = 0; // Start on Lessons screen

  // The list of all three screens our app will have.
  final List<Widget> _screenWidgets = [
    // Placeholder for Lessons Screen
    const Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(child: Text('Lessons Screen', style: TextStyle(color: Colors.white))),
    ),
    // The real Reflect screen
    const ReflectScreen(), 
    // Placeholder for Calendar Screen
    const Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(child: Text('Calendar Screen', style: TextStyle(color: Colors.white))),
    ),
  ];

  void _onItemTapped(int index) {
    // When a tab is tapped, we simply update the state to show the corresponding screen.
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body now shows one of our three main screens based on the selected index.
      body: _screenWidgets[_selectedIndex],
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
            // We need a dummy IconButton for the central space to ensure correct alignment.
            // It's disabled with an empty onPressed.
            IconButton(
              onPressed: null,
              icon: const SizedBox(width: 60), // Spacer
            ),
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
          onTap: () => _onItemTapped(1), // Tapping this selects the middle screen (ReflectScreen)
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