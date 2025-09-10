import 'package:flutter/material.dart';
import 'package:flutter_app_1/utils/database_helper.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  LessonsScreenState createState() => LessonsScreenState();
}

class LessonsScreenState extends State<LessonsScreen> {
  late Future<List<Lesson>> _lessonsFuture;

  @override
  void initState() {
    super.initState();
    _lessonsFuture = _fetchLessons();
  }

  Future<List<Lesson>> _fetchLessons() {
    // We get the lessons and reverse them so the newest appears first
    return DatabaseHelper.instance.getAllLessons().then((lessons) => lessons.reversed.toList());
  }

  void refreshLessons() {
    setState(() {
      _lessonsFuture = _fetchLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. The Background Image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/cabin_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // This adds a dark overlay to ensure text is always readable
        Container(
           color: Colors.black.withOpacity(0.3),
        ),
        // 2. The UI Content (on top of the image)
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
                child: FutureBuilder<List<Lesson>>(
                  future: _lessonsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final lessons = snapshot.data!;
                      // This is the full-screen, vertically scrolling feed
                      return PageView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                lessons[index].lesson,
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
                      );
                    } else {
                      // Show this if there are no lessons yet
                      return const Center(
                        child: Text(
                          'No lessons saved yet.\nTap the + button to add one.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      );
                    }
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