import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Step 1: Import the new package

class ReflectScreen extends StatefulWidget {
  const ReflectScreen({super.key});

  @override
  State<ReflectScreen> createState() => _ReflectScreenState();
}

class _ReflectScreenState extends State<ReflectScreen> {
  final TextEditingController _incidentController = TextEditingController();
  final TextEditingController _lessonController = TextEditingController();
  bool _isSaveButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _incidentController.addListener(_updateSaveButtonState);
    _lessonController.addListener(_updateSaveButtonState);
  }

  @override
  void dispose() {
    _incidentController.removeListener(_updateSaveButtonState);
    _lessonController.removeListener(_updateSaveButtonState);
    _incidentController.dispose();
    _lessonController.dispose();
    super.dispose();
  }

  void _updateSaveButtonState() {
    setState(() {
      _isSaveButtonEnabled =
          _incidentController.text.isNotEmpty && _lessonController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Step 2: Get the current date and format it
    final String formattedDate = DateFormat('EEEE, \nd MMMM yyyy').format(DateTime.now());

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 44),
              
              // The REFLECT title now sits alone
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
              
              // Step 3: New Row for the Date and Save button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start, // Aligns items to the top
                children: [
                  // The Date text now uses our formattedDate variable
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Color(0xB7EAEAEA),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // The Save button, moved here
                  OutlinedButton(
                    onPressed: _isSaveButtonEnabled ? () {
                      print('Save button tapped!');
                    } : null,
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
                    color: Color(0xBFAEAEAE),
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
                  color: Color(0xBFAEAEAE),
                  fontFamily: 'Jomolhari',
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  hintText: 'What did I learn?',
                  hintStyle: const TextStyle(
                    color: Color(0xBFAEAEAE),
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