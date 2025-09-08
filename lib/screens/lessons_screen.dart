import 'package:flutter/material.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  // This is our list of mock (fake) data for the lessons.
  final List<String> lessons = [
    'Embrace change',
    'Trust your intuition',
    'Failure is a teacher',
  ];

  @override
  Widget build(BuildContext context) {
    // We use a Stack to layer the UI on top of the background image.
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

        // 2. The UI Content (on top of the image)
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // This is the header with the title
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
              
              // This is the main scrolling area for the lessons
              Expanded(
                child: PageView.builder(
                  // This tells the PageView how many items (lessons) we have.
                  scrollDirection: Axis.vertical,
                  itemCount: lessons.length,
                  // This builder is called for each lesson to create its page.
                  itemBuilder: (context, index) {
                    return Center(
                      child: Text(
                        lessons[index], // Display the lesson text
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30, // You can adjust this size
                          fontFamily: 'Jaldi',
                          fontWeight: FontWeight.w600,
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