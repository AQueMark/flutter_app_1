import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF1E1E1E).withOpacity(0.98),
      height: 80,
      elevation: 0,
      padding: EdgeInsets.zero,
      // This shape creates the "notch" for the floating action button
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            onPressed: () => onItemSelected(0),
            icon: SvgPicture.asset(
              selectedIndex == 0 ? 'assets/icons/book_icon_white.svg' : 'assets/icons/book_icon_grey.svg',
              width: 32,
              height: 32,
            ),
          ),
          // This SizedBox acts as a placeholder for the FAB
          const SizedBox(width: 60),
          IconButton(
            onPressed: () => onItemSelected(2),
            icon: SvgPicture.asset(
              selectedIndex == 2 ? 'assets/icons/calendar_icon_white.svg' : 'assets/icons/calendar_icon_grey.svg',
              width: 32,
              height: 32,
            ),
          ),
        ],
      ),
    );
  }
}

// We create a separate widget for the FAB to use in main.dart
class ReflectFloatingActionButton extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onPressed;

  const ReflectFloatingActionButton({
    super.key,
    required this.selectedIndex,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // The FAB is pushed down by 40px from its original centered location
    return Transform.translate(
      offset: const Offset(0, 40),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            color: Color(0xFF282828),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              selectedIndex == 1 ? 'assets/icons/add_icon_white.svg' : 'assets/icons/add_icon_grey.svg',
              width: 43,
              height: 43,
            ),
          ),
        ),
      ),
    );
  }
}