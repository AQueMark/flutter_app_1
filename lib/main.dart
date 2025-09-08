import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app_1/screens/reflect_screen.dart';
import 'package:flutter_app_1/screens/calendar_screen.dart';
import 'package:flutter_app_1/screens/lessons_screen.dart';

// Assuming you will create this file for the Lessons screen
// import 'package:flutter_app_1/screens/lessons_screen.dart';

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
  int _selectedIndex = 0;

  final List<Widget> _screenWidgets = [
    const LessonsScreen(),
    const ReflectScreen(),
    const CalendarScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            IconButton(
              onPressed: null,
              icon: const SizedBox(width: 60),
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
        // We now use our new custom widget here
        child: CustomCentralButton(
          onTap: () => _onItemTapped(1),
          isSelected: _selectedIndex == 1,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// NEW CUSTOM BUTTON WIDGET
// This widget handles its own press and release animations.
// -----------------------------------------------------------------
class CustomCentralButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isSelected;

  const CustomCentralButton({
    super.key,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<CustomCentralButton> createState() => _CustomCentralButtonState();
}

class _CustomCentralButtonState extends State<CustomCentralButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0, // Shrinks when pressed
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: const Color(0xFF282828),
            shape: BoxShape.circle,
            boxShadow: [
              if (_isPressed) // Adds a subtle glow when pressed
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              widget.isSelected ? 'assets/icons/add_icon_white.svg' : 'assets/icons/add_icon_grey.svg',
              width: 43,
              height: 43,
            ),
          ),
        ),
      ),
    );
  }
}