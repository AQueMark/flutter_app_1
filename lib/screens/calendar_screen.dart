import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_app_1/utils/database_helper.dart';
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
  final AuthService _authService = AuthService();

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // --- NEW: Confirmation Dialog Method ---
  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF282828),
          title: const Text('Delete Account?', style: TextStyle(color: Colors.white)),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'This is permanent and cannot be undone.',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 8),
                Text(
                  'All your journal entries will be lost forever.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('DELETE', style: TextStyle(color: Colors.redAccent)),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
                
                final result = await _authService.deleteAccount();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result),
                      backgroundColor: result.startsWith("Error") ? Colors.redAccent : Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _authService.signOut();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
                title: const Text('Delete Account', style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  // Pop the bottom sheet first
                  Navigator.pop(context);
                  // Then show the new confirmation dialog
                  _showDeleteConfirmationDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined, color: Colors.white),
                title: const Text('Terms of Service', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  print('Terms of Service tapped');
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  // The rest of your CalendarScreen code remains unchanged
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
                    icon: Icon(Icons.settings, color: Colors.grey[600]),
                    onPressed: () {
                      _showSettingsBottomSheet(context);
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