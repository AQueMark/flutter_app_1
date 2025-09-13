import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_1/services/firestore_service.dart';
import 'package:flutter_app_1/utils/database_helper.dart';
import 'package:table_calendar/table_calendar.dart';

class ReflectScreen extends StatefulWidget {
  final DateTime date;
  final List<Lesson> allLessons;
  final VoidCallback onDataChanged;
  final bool isOpenedFromLessons;
  final User? currentUser;

  const ReflectScreen({
    super.key,
    required this.date,
    required this.allLessons,
    required this.onDataChanged,
    this.isOpenedFromLessons = false,
    required this.currentUser,
  });

  @override
  State<ReflectScreen> createState() => _ReflectScreenState();
}

class _ReflectScreenState extends State<ReflectScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late TextEditingController _incidentController;
  late TextEditingController _lessonController;
  bool _isSaveButtonEnabled = false;
  Lesson? _existingLesson;

  String _initialIncidentText = '';
  String _initialLessonText = '';

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _incidentController = TextEditingController();
    _lessonController = TextEditingController();

    _findLessonForDate();

    _incidentController.addListener(_updateSaveButtonState);
    _lessonController.addListener(_updateSaveButtonState);
  }

  @override
  void didUpdateWidget(ReflectScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.allLessons != oldWidget.allLessons) {
      setState(() {
        _findLessonForDate();
        _updateSaveButtonState();
      });
    }
  }
  
  void _findLessonForDate() {
    final dayOnly = DateTime(widget.date.year, widget.date.month, widget.date.day);
    try {
      _existingLesson = widget.allLessons.firstWhere((lesson) {
        final lessonDayOnly = DateTime(lesson.date.year, lesson.date.month, lesson.date.day);
        return isSameDay(lessonDayOnly, dayOnly);
      });
      _incidentController.text = _existingLesson!.incident;
      _lessonController.text = _existingLesson!.lesson;
    } catch (e) {
      _existingLesson = null;
      _incidentController.text = '';
      _lessonController.text = '';
    }
    _initialIncidentText = _incidentController.text;
    _initialLessonText = _lessonController.text;
  }

  @override
  void dispose() {
    _incidentController.dispose();
    _lessonController.dispose();
    super.dispose();
  }

  void _updateSaveButtonState() {
    final isNotEmpty = _incidentController.text.trim().isNotEmpty && _lessonController.text.trim().isNotEmpty;
    final hasChanged = _incidentController.text != _initialIncidentText ||
        _lessonController.text != _initialLessonText;

    if (_isSaveButtonEnabled != (hasChanged && isNotEmpty)) {
       setState(() {
        _isSaveButtonEnabled = hasChanged && isNotEmpty;
      });
    }
  }

  Future<void> _saveLesson() async {
    if (widget.currentUser == null) return;

    setState(() {
      _isSaving = true;
    });

    final lesson = Lesson(
      id: _existingLesson?.id,
      userId: widget.currentUser!.uid,
      incident: _incidentController.text,
      lesson: _lessonController.text,
      date: widget.date,
    );
    await _firestoreService.upsertLesson(lesson);
    
    widget.onDataChanged(); 

    if (mounted) {
      setState(() {
        _isSaving = false;
      });
      if (widget.isOpenedFromLessons) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _deleteLesson() async {
    if (_existingLesson?.id == null) return;

    final bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        title: const Text('Delete Entry?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    ) ?? false;

    if (confirmDelete) {
      await _firestoreService.deleteLesson(_existingLesson!.id!);
      widget.onDataChanged(); 
      if (widget.isOpenedFromLessons && mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, \nd MMMM yyyy').format(widget.date);
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (widget.isOpenedFromLessons && details.primaryVelocity! > 100) {
              Navigator.of(context).pop();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 44),
                    const Text('REFLECT', style: TextStyle(color: Color(0xFCEAEAEA), fontSize: 32, fontFamily: 'K2D', fontWeight: FontWeight.w400, letterSpacing: 2.40)),
                    const SizedBox(height: 38),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(formattedDate, style: const TextStyle(color: Color(0xB7EAEAEA), fontSize: 18, fontFamily: 'Inter', fontWeight: FontWeight.w400)),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: _isSaveButtonEnabled ? _saveLesson : null,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: _isSaveButtonEnabled ? Colors.white : Colors.transparent,
                                side: BorderSide(width: 2.5, color: _isSaveButtonEnabled ? Colors.white : Colors.grey.shade800),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              ),
                              child: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                    ),
                                  )
                                : Text('Save', style: TextStyle(color: _isSaveButtonEnabled ? Colors.black : Colors.grey[600], fontFamily: 'Inter', fontWeight: FontWeight.bold)),
                            ),
                            if (_existingLesson != null)
                              IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.grey[600]),
                                onPressed: _deleteLesson,
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 42),
                    const Text('THE INCIDENT', style: TextStyle(color: Color(0xEDEAEAEA), fontSize: 19, fontFamily: 'K2D', fontWeight: FontWeight.w400)),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _incidentController,
                      maxLines: 8,
                      style: const TextStyle(color: Color(0xBFAEAEAEA), fontFamily: 'K2D', fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Describe the event or feeling without judgment..',
                        hintStyle: const TextStyle(color: Color(0xB7EAEAEA), fontFamily: 'K2D', fontSize: 18),
                        filled: true,
                        fillColor: const Color(0xFF282828),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('THE LESSON', style: TextStyle(color: Color(0xEDEAEAEA), fontSize: 19, fontFamily: 'K2D', fontWeight: FontWeight.w400)),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _lessonController,
                      maxLines: 4,
                      style: const TextStyle(color: Color(0xBFAEAEAEA), fontFamily: 'K2D', fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'What did I learn?',
                        hintStyle: const TextStyle(color: Color(0xB7EAEAEA), fontFamily: 'K2D', fontSize: 18),
                        filled: true,
                        fillColor: const Color(0xFF282828),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}