import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app_1/utils/database_helper.dart';
import 'package:flutter_app_1/main.dart'; // Import added here

class ReflectScreen extends StatefulWidget {
  final DateTime? date;

  const ReflectScreen({
    super.key,
    this.date,
  });

  @override
  State<ReflectScreen> createState() => _ReflectScreenState();
}

class _ReflectScreenState extends State<ReflectScreen> {
  late TextEditingController _incidentController;
  late TextEditingController _lessonController;
  bool _isSaveButtonEnabled = false;
  late DateTime _currentDate;
  Lesson? _existingLesson;

  String _initialIncidentText = '';
  String _initialLessonText = '';

  @override
  void initState() {
    super.initState();
    _currentDate = widget.date ?? DateTime.now();
    
    _incidentController = TextEditingController();
    _lessonController = TextEditingController();

    _loadLessonForDate(_currentDate);

    _incidentController.addListener(_updateSaveButtonState);
    _lessonController.addListener(_updateSaveButtonState);
  }

  @override
  void didUpdateWidget(covariant ReflectScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.date != oldWidget.date && widget.date != null) {
      _currentDate = widget.date!;
      _loadLessonForDate(_currentDate);
    }
  }

  Future<void> _loadLessonForDate(DateTime date) async {
    final dayOnly = DateTime(date.year, date.month, date.day);
    _incidentController.clear();
    _lessonController.clear();
    _initialIncidentText = '';
    _initialLessonText = '';
    _existingLesson = null;

    final lessons = await DatabaseHelper.instance.getLessonsForDay(dayOnly);
    if (lessons.isNotEmpty && mounted) {
      setState(() {
        _existingLesson = lessons.first;
        _incidentController.text = _existingLesson!.incident;
        _lessonController.text = _existingLesson!.lesson;
        _initialIncidentText = _existingLesson!.incident;
        _initialLessonText = _existingLesson!.lesson;
      });
    }
  }

  @override
  void dispose() {
    _incidentController.dispose();
    _lessonController.dispose();
    super.dispose();
  }

  void _updateSaveButtonState() {
    final bool isNotEmpty = _incidentController.text.isNotEmpty && _lessonController.text.isNotEmpty;
    final bool hasChanged = _incidentController.text != _initialIncidentText ||
                           _lessonController.text != _initialLessonText;

    setState(() {
      _isSaveButtonEnabled = hasChanged && isNotEmpty;
    });
  }

  void _saveLesson() async {
    final lesson = Lesson(
      incident: _incidentController.text,
      lesson: _lessonController.text,
      date: _currentDate,
    );
    
    await DatabaseHelper.instance.upsert(lesson);

    if (mounted) {
      final mainScreenState = context.findAncestorStateOfType<MainScreenState>();
      mainScreenState?.navigateToLessonsAndRefresh();
    }
  }

  void _deleteLesson() async {
    final bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        title: const Text('Delete Entry?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    ) ?? false;

    if (confirmDelete && mounted) {
      await DatabaseHelper.instance.delete(_currentDate);
      final mainScreenState = context.findAncestorStateOfType<MainScreenState>();
      mainScreenState?.navigateToCalendarAndRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, \nd MMMM yyyy').format(_currentDate);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 44),
              const Text(
                'REFLECT',
                style: TextStyle(
                  color: Color(0xFCEAEAEA),
                  fontSize: 32,
                  fontFamily: 'K2D',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.40,
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Color(0xB7EAEAEA),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      if (_existingLesson != null)
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.grey[600]),
                          onPressed: _deleteLesson,
                        ),
                      OutlinedButton(
                        onPressed: _isSaveButtonEnabled ? _saveLesson : null,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: _isSaveButtonEnabled ? Colors.white : Colors.transparent,
                          side: BorderSide(
                            width: 1.5,
                            color: _isSaveButtonEnabled ? Colors.white : Colors.grey.shade800,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: _isSaveButtonEnabled ? Colors.black : Colors.grey[600],
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 48),
              const Text(
                'THE INCIDENT',
                style: TextStyle(
                  color: Color(0xEDEAEAEA),
                  fontSize: 22,
                  fontFamily: 'Jaldi',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _incidentController,
                 maxLines: 8,
                style: const TextStyle(
                  color: Color(0xBFAEAEAE),
                  fontFamily: 'Jomolhari',
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  hintText: 'Describe the event or feeling without judgment..',
                  hintStyle: const TextStyle(
                    color: Color(0xBFAEAEAEA),
                    fontFamily: 'Jomolhari',
                    fontSize: 17,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF282828),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'THE LESSON',
                style: TextStyle(
                  color: Color(0xEDEAEAEA),
                  fontSize: 22,
                  fontFamily: 'Jaldi',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _lessonController,
                maxLines: 4,
                style: const TextStyle(
                  color: Color(0xBFAEAEAEA),
                  fontFamily: 'Jomolhari',
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  hintText: 'What did I learn?',
                  hintStyle: const TextStyle(
                    color: Color(0xBFAEAEAEA),
                    fontFamily: 'Jomolhari',
                    fontSize: 17,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF282828),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}