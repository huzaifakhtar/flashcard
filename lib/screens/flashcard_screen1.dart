// File: /lib/screens/flashcard_screen.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'result_screen.dart';
// import 'settings_screen.dart';

class Flashcard {
  final String question;
  final String answer;

  Flashcard({required this.question, required this.answer});
}

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  final List<Flashcard> flashcards = [
    Flashcard(question: 'Who developed Flutter?', answer: 'Google'),
    Flashcard(question: 'What language does Flutter use?', answer: 'Dart'),
    Flashcard(
        question: 'What is Flutter?',
        answer:
            'A UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.'),
    Flashcard(question: 'Who developed Flutter?', answer: 'Google'),
    Flashcard(question: 'What language does Flutter use?', answer: 'Dart'),
    Flashcard(
        question: 'What is Flutter?',
        answer:
            'A UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.'),
    Flashcard(question: 'Who developed Flutter?', answer: 'Google'),
    Flashcard(question: 'What language does Flutter use?', answer: 'Dart'),
  ];

  int currentIndex = 0;
  bool showQuestion = true;
  late AnimationController _controller;
  late Animation<double> _animation;
  Offset _startSwipeOffset = Offset.zero;
  Offset _endSwipeOffset = Offset.zero;
  Offset _currentSwipeOffset = Offset.zero;

  int knownCount = 0;
  int notKnownCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flipCard() {
    if (_controller.isCompleted || _controller.isDismissed) {
      _controller.forward(from: 0.0);
      Future.delayed(const Duration(milliseconds: 280), () {
        setState(() {
          showQuestion = !showQuestion;
        });
      });
    }
  }

  void handleSwipe(Offset start, Offset end) {
    final dx = end.dx - start.dx;
    if (dx.abs() < 100) {
      handleSwipeDirection("nothing");
    } else if (dx > 0) {
      handleSwipeDirection("right");
    } else {
      handleSwipeDirection("left");
    }
  }

  void handleSwipeDirection(String direction) {
    setState(() {
      if (direction == "right") {
        knownCount++;
      } else if (direction == "left") {
        notKnownCount++;
      } else {
        // print('No action taken');
        _currentSwipeOffset = Offset.zero;
        return;
      }

      if (currentIndex < flashcards.length - 1) {
        currentIndex++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultScreen(),
          ),
        );
        return;
      }
      showQuestion = true;
      _currentSwipeOffset = Offset.zero;
    });
  }

  void shuffleFlashcards() {
    setState(() {
      flashcards.shuffle();
      currentIndex = 0;
      showQuestion = true;
    });
  }

  void restartFlashcards() {
    setState(() {
      currentIndex = 0;
      showQuestion = true;
    });
  }

  // void openSettings() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SettingsScreen(
  //         onShuffleFlashcards: shuffleFlashcards,
  //         onRestartFlashcards: restartFlashcards,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    double opacity = min(_currentSwipeOffset.dx.abs() / 100, 1.0);
    double rotationAngle = _currentSwipeOffset.dx / 500;
    double progress = (currentIndex + 1) / flashcards.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth * 0.9;
        double cardHeight = constraints.maxHeight * 0.65;

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 13, 26, 57),
                foregroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text('${currentIndex + 1}/${flashcards.length}'),
                centerTitle: true,
                // actions: [
                //   IconButton(
                //     icon: Icon(Icons.settings),
                //     onPressed: openSettings,
                //   ),
                // ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(4.0),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    color: Colors.blue,
                  ),
                ),
              ),
              body: Container(
                color: const Color.fromARGB(255, 13, 26, 57),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        width: cardWidth,
                        height: cardHeight,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 84, 93, 141),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: cardHeight * 0.125),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (currentIndex > 0) {
                              setState(() {
                                currentIndex--;
                                showQuestion = true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                          ),
                          child: const Icon(
                            Icons.reply,
                            size: 35,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (currentIndex < flashcards.length - 1) {
                              setState(() {
                                currentIndex++;
                                showQuestion = true;
                              });
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ResultScreen(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onPanStart: (DragStartDetails details) {
                  _startSwipeOffset = details.localPosition;
                },
                onPanUpdate: (details) {
                  setState(() {
                    _currentSwipeOffset = details.localPosition - _startSwipeOffset;
                  });
                },
                onPanEnd: (details) {
                  _endSwipeOffset = details.localPosition;
                  handleSwipe(_startSwipeOffset, _endSwipeOffset);
                },
                onTap: flipCard,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final isUnder = _controller.value < 0.5;
                    final value =
                        isUnder ? _controller.value : 1 - _controller.value;
                    return Transform(
                      transform: Matrix4.rotationY(value * pi)
                        ..translate(_currentSwipeOffset.dx, _currentSwipeOffset.dy)
                        ..rotateZ(rotationAngle),
                      alignment: Alignment.center,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: _currentSwipeOffset.dx > 0
                                ? Colors.greenAccent.withOpacity(opacity)
                                : Colors.redAccent.withOpacity(opacity),
                            width: 5,
                          ),
                        ),
                        child: Container(
                          width: cardWidth,
                          height: cardHeight,
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 84, 93, 141),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            showQuestion
                                ? flashcards[currentIndex].question
                                : flashcards[currentIndex].answer,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
