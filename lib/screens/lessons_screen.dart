import 'package:flutter/material.dart';
import 'package:flutter_app_1/utils/database_helper.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  LessonsScreenState createState() => LessonsScreenState();
}

class LessonsScreenState extends State<LessonsScreen> {
  // We will store the final list of lessons here
  List<Lesson> _lessons = [];
  // This will track if the data is still loading
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndPrepareLessons();
  }

  Future<void> _fetchAndPrepareLessons() async {
    final fetchedLessons = await DatabaseHelper.instance.getAllLessons();
    if (mounted) {
      setState(() {
        // We reverse the list here and store it in our state variable
        _lessons = fetchedLessons.reversed.toList();
        _isLoading = false;
      });
    }
  }

  void refreshLessons() {
    setState(() {
      _isLoading = true; // Show loading indicator while refreshing
    });
    _fetchAndPrepareLessons();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/cabin_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
           color: Colors.black.withOpacity(0.3),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 44),
                    Text(
                      'LESSONS',
                      style: TextStyle(
                        color: Color(0xFCEAEAEA),
                        fontSize: 32,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2.40,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _lessons.isEmpty
                      ? const Center(
                          child: Text(
                            'No lessons saved yet.\nTap the + button to add one.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      : PageView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 10000, // For infinite scroll
                          itemBuilder: (context, index) {
                            final lesson = _lessons[index % _lessons.length];
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Text(
                                  lesson.lesson,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontFamily: 'Jaldi',
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(blurRadius: 10.0, color: Colors.black),
                                    ]
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}