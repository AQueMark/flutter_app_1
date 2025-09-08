import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final List<DateTime> _daysWithEntries = [
    DateTime.utc(2025, 9, 2),
    DateTime.utc(2025, 9, 10),
    DateTime.utc(2025, 9, 15),
    DateTime.utc(2025, 9, 22),
  ];

  @override
  Widget build(BuildContext context) {
    final bool hasEntry = _daysWithEntries.any((day) => isSameDay(day, _selectedDay));

    return SafeArea(
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
            const SizedBox(height: 36),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: const Color.fromARGB(255, 44, 44, 44), width: 0.5),
                ),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
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
                daysOfWeekHeight: 44.0,
                // --- STYLING SECTION ---
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: const TextStyle(
                    color: Color(0xB7EAEAEA),
                    fontSize: 23,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  headerPadding: const EdgeInsets.only(top: 16.0, bottom: 44.0),
                ),
                daysOfWeekStyle: DaysOfWeekStyle( // CONST REMOVED
                  weekdayStyle: const TextStyle(color: Color(0xB7EAEAEA), fontSize: 24),
                  weekendStyle: const TextStyle(color: Color(0xB7EAEAEA), fontSize: 24),
                  decoration: BoxDecoration(
                     border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 44, 44, 44), width: 0.5)),
                  )
                ),
                calendarStyle: CalendarStyle( // CONST REMOVED
                  defaultTextStyle: const TextStyle(color: Colors.white, fontSize: 21),
                  weekendTextStyle: const TextStyle(color: Colors.white, fontSize: 21),
                  outsideDaysVisible: false,
                   rowDecoration: BoxDecoration(
                     border: Border(top: BorderSide(color: const Color.fromARGB(255, 44, 44, 44), width: 0.5)),
                   )
                ),
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    final text = DateFormat.E().format(day);
                    return Center(
                      child: Text(
                        text.substring(0, 1),
                        style: const TextStyle(color: Color(0xB7EAEAEA), fontSize: 22),
                      ),
                    );
                  },
                  defaultBuilder: (context, day, focusedDay) {
                    if (_daysWithEntries.any((entryDay) => isSameDay(entryDay, day))) {
                      return Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(color: Color.fromARGB(255, 12, 122, 83), fontSize: 22),
                        ),
                      );
                    }
                    return null;
                  },
                  selectedBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(8.0),
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
              child:SizedBox(
                width:175,            
              child: ElevatedButton(
                onPressed: () {
                  print('Button tapped for date: $_selectedDay');
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
            )),
            const SizedBox(height: 62),
          ],
        ),
      ),
    );
  }
}