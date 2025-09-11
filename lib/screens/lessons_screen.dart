import 'package:flutter/material.dart';
import 'package:flutter_app_1/utils/database_helper.dart';
import 'package:flutter_app_1/screens/reflect_screen.dart';

class LessonsScreen extends StatefulWidget {
  // --- CHANGE: Receive master list of lessons and a refresh callback ---
  final List<Lesson> allLessons;
  final VoidCallback onDataChanged;

  const LessonsScreen({
    super.key,
    required this.allLessons,
    required this.onDataChanged,
  });

  @override
  LessonsScreenState createState() => LessonsScreenState();
}

class LessonsScreenState extends State<LessonsScreen> with AutomaticKeepAliveClientMixin<LessonsScreen> {
  final PageController _verticalController = PageController(initialPage: 5000);
  List<Lesson> _lessons = [];
  int _currentLessonIndexInPage = 0; // Renamed to avoid confusion

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // --- CHANGE: Use the data passed from MainScreen instead of fetching ---
    _lessons = widget.allLessons.reversed.toList();
  }

  @override
  void didUpdateWidget(LessonsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // --- CHANGE: If the master list changes, update the local reversed list ---
    if (widget.allLessons != oldWidget.allLessons) {
      setState(() {
        _lessons = widget.allLessons.reversed.toList();
      });
    }
  }

  @override
  void dispose() {
    _verticalController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);

    // --- YOUR ORIGINAL UI AND GESTURES ARE PRESERVED HERE ---
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < -100 && _lessons.isNotEmpty) {
          Navigator.of(context).push(_createSlideRoute());
        }
      },
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/cabin_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),
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
                  child: _lessons.isEmpty
                      ? const Center(
                          child: Text(
                            'No lessons saved yet.\nTap the + button to add one.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      : NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollEndNotification && _lessons.isNotEmpty) {
                              final newIndex = _verticalController.page?.round() ?? 0;
                              final loopedIndex = newIndex % _lessons.length;
                              if (loopedIndex != _currentLessonIndexInPage) {
                                setState(() {
                                  _currentLessonIndexInPage = loopedIndex;
                                });
                              }
                            }
                            return true;
                          },
                          child: PageView.builder(
                            controller: _verticalController,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              if (_lessons.isEmpty) return Container();
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
                                        ]),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Route _createSlideRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ReflectScreen(
        // --- CHANGE: Pass all necessary data for an instant load ---
        date: _lessons[_currentLessonIndexInPage].date,
        allLessons: widget.allLessons,
        onDataChanged: widget.onDataChanged,
        isOpenedFromLessons: true,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}