import 'package:flutter/material.dart';
import 'package:flutter_app_1/utils/database_helper.dart';
import 'package:flutter_app_1/screens/reflect_screen.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  LessonsScreenState createState() => LessonsScreenState();
}

class LessonsScreenState extends State<LessonsScreen> with AutomaticKeepAliveClientMixin<LessonsScreen> {
  final PageController _verticalController = PageController(initialPage: 5000);
  List<Lesson> _lessons = [];
  bool _isLoading = true;
  int _currentLessonIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchAndPrepareLessons();
  }

  @override
  void dispose() {
    _verticalController.dispose();
    super.dispose();
  }

  Future<void> _fetchAndPrepareLessons() async {
    final fetchedLessons = await DatabaseHelper.instance.getAllLessons();
    if (mounted) {
      setState(() {
        _lessons = fetchedLessons.reversed.toList();
        _isLoading = false;
      });
    }
  }

  void refreshLessons() {
    setState(() {
      _isLoading = true;
    });
    _fetchAndPrepareLessons();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
                          // THIS IS THE FIX: We wrap the PageView in a NotificationListener
                          : NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                if (notification is ScrollEndNotification && _lessons.isNotEmpty) {
                                  final newIndex = _verticalController.page?.round() ?? 0;
                                  final loopedIndex = newIndex % _lessons.length;
                                  if (loopedIndex != _currentLessonIndex) {
                                    setState(() {
                                      _currentLessonIndex = loopedIndex;
                                    });
                                  }
                                }
                                return true; // We've handled the notification
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
        date: _lessons[_currentLessonIndex].date,
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