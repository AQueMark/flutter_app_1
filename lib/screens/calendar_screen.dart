import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_app_1/utils/database_helper.dart';

class CalendarScreen extends StatefulWidget {
  // --- CHANGE: Receive the list of all lessons and the navigation callback ---
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
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // --- REMOVED: No longer needs its own Future or refresh logic ---

  List<Lesson> _getLessonsForDay(DateTime day) {
    final dayOnly = DateTime(day.year, day.month, day.day);
    // --- CHANGE: Use the lesson list passed into the widget ---
    return widget.allLessons.where((lesson) {
      final lessonDayOnly = DateTime(lesson.date.year, lesson.date.month, lesson.date.day);
      return isSameDay(lessonDayOnly, dayOnly);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // --- REMOVED: FutureBuilder is no longer needed ---
    
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
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade900, width: 0.5),
                  ),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.now().add(const Duration(days: 1)), // Only allow up to today
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
                  daysOfWeekHeight: 40,
                  enabledDayPredicate: (date) {
                    return !date.isAfter(DateTime.now());
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: const TextStyle(
                      color: Color(0xB7EAEAEA),
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                    headerPadding: const EdgeInsets.only(top: 16.0, bottom: 34.0),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: const TextStyle(color: Color(0xB7EAEAEA), fontSize: 19),
                    weekendStyle: const TextStyle(color: Color(0xB7EAEAEA), fontSize: 19),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade900, width: 0.5)),
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colors.white, fontSize: 19),
                    weekendTextStyle: const TextStyle(color: Colors.white, fontSize: 19),
                    outsideDaysVisible: false,
                    rowDecoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey.shade900, width: 0.5)),
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    disabledBuilder: (context, date, events) => Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(color: Colors.grey.shade800, fontSize: 18),
                      ),
                    ),
                    dowBuilder: (context, day) {
                      final text = DateFormat.E().format(day);
                      return Center(
                        child: Text(
                          text.substring(0, 1),
                          style: const TextStyle(color: Color(0xB7EAEAEA), fontSize: 19),
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
                            style: const TextStyle(color: Colors.white, fontSize: 19),
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
                      child: Text('${date.day}', style: const TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 175,
                  child: ElevatedButton(
                    onPressed: () {
                      // --- CHANGE: Use the callback to navigate ---
                      widget.onNavigateToReflect(_selectedDay);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE0E0E0),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                    ),
                    child: Text(
                      hasEntry ? 'VIEW' : 'ADD',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 62),
            ],
          ),
        ),
      ),
    );
  }
}