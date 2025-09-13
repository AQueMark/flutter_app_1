import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_app_1/utils/database_helper.dart';
// --- ADDED: Import for the AuthService ---
import 'package:flutter_app_1/services/auth_service.dart';

class CalendarScreen extends StatefulWidget {
  final List<Lesson> allLessons;
  final Function(DateTime) onNavigateToReflect;

  const CalendarScreen({
    super.key,
    required this.allLessons,
    required this.onNavigateToReflect,
  });

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  // --- ADDED: Instance of the AuthService ---
  final AuthService _authService = AuthService();

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<Lesson> _getLessonsForDay(DateTime day) {
    final dayOnly = DateTime(day.year, day.month, day.day);
    return widget.allLessons.where((lesson) {
      final lessonDayOnly = DateTime(lesson.date.year, lesson.date.month, lesson.date.day);
      return isSameDay(lessonDayOnly, dayOnly);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lessonsForSelectedDay = _getLessonsForDay(_selectedDay);
    final bool hasEntry = lessonsForSelectedDay.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 44),
              // --- MODIFIED: The title is now in a Row with the logout button ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'REMEMBER',
                    style: TextStyle(
                      color: Color(0xFCEAEAEA),
                      fontSize: 32,
                      fontFamily: 'K2D',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2.40,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: Colors.grey[600]),
                    onPressed: () {
                      // Call the signOut method from our service
                      _authService.signOut();
                      // The AuthGate will handle navigation
                    },
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade900, width: 0.5),
                  ),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.now().add(const Duration(days: 1)),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  rowHeight: 60,
                  daysOfWeekHeight: 60,
                  enabledDayPredicate: (date) {
                    return !date.isAfter(DateTime.now());
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: const TextStyle(
                      color: Color.fromARGB(255, 231, 229, 229),
                      fontSize: 22,
                      fontFamily: 'K2D',
                      fontWeight: FontWeight.w400,
                    ),
                    headerPadding: const EdgeInsets.only(top: 16.0, bottom: 34.0),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: const TextStyle(color: Color(0xB7EAEAEA), fontSize: 19,fontFamily: 'K2D'),
                    weekendStyle: const TextStyle(color: Color(0xB7EAEAEA), fontSize: 19,fontFamily: 'K2D'),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade900, width: 0.5)),
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colors.white, fontSize: 19,fontFamily: 'K2D'),
                    weekendTextStyle: const TextStyle(color: Colors.white, fontSize: 19,fontFamily: 'K2D'),
                    outsideDaysVisible: false,
                    rowDecoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey.shade900, width: 0.5)),
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    disabledBuilder: (context, date, events) => Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(color: Colors.grey.shade800, fontSize: 18, fontFamily: 'K2D'),
                      ),
                    ),
                    dowBuilder: (context, day) {
                      final text = DateFormat.E().format(day);
                      return Center(
                        child: Text(
                          text.substring(0, 1),
                          style: const TextStyle(color: Color(0xB7EAEAEA), fontSize: 19,fontFamily: 'K2D'),
                        ),
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      if (_getLessonsForDay(day).isNotEmpty) {
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white, fontSize: 19,fontFamily: 'K2D'),
                          ),
                        );
                      }
                      return null;
                    },
                    selectedBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(6.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        shape: BoxShape.circle,
                      ),
                      child: Text('${date.day}', style: const TextStyle(color: Colors.white, fontSize: 18,fontFamily: 'K2D')),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onNavigateToReflect(_selectedDay);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE0E0E0),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    ),
                    child: Text(
                      hasEntry ? 'VIEW' : 'ADD',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 75),
            ],
          ),
        ),
      ),
    );
  }
}