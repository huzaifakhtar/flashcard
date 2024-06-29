import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flip_card/flip_card.dart';

class Flashcard {
  final String question, answer;
  Flashcard({required this.question, required this.answer});
}

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int knownCount = 0, notKnownCount = 0, currentIndex = 0;
  final Offset _startSwipeOffset = Offset.zero;
  Offset _currentSwipeOffset = Offset.zero;
  final AppinioSwiperController controller = AppinioSwiperController();
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

  void shuffleFlashcards() {
    setState(() {
      flashcards.shuffle();
      currentIndex = 0;
      controller.setCardIndex(currentIndex);
    });
  }

  void restartFlashcards() {
    setState(() {
      currentIndex = 0;
      controller.setCardIndex(currentIndex);
      notKnownCount = 0;
      knownCount = 0;
    });
  }

  void openSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  shuffleFlashcards();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Shuffle Flashcards'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  restartFlashcards();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Restart Flashcards'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _swipeEnd(int previousIndex, int targetIndex, SwiperActivity activity) {
    setState(() {
      currentIndex = targetIndex; // Update the index here
    });
    switch (activity) {
      case Swipe():
        if (activity.direction.name == 'right') {
          knownCount++;
        } else if (activity.direction.name == 'left') {
          notKnownCount++;
        }
        print('The card was swiped to the : ${activity.direction}');
        print('previous index: $previousIndex, target index: $targetIndex');
        break;
      case Unswipe():
        if (activity.direction.name == 'right') {
          knownCount--;
        } else if (activity.direction.name == 'left') {
          notKnownCount--;
        }
        print('A ${activity.direction.name} swipe was undone.');
        print('previous index: $previousIndex, target index: $targetIndex');
        break;
      case CancelSwipe():
        print('A swipe was cancelled');
        break;
      case DrivenActivity():
        print('Driven Activity');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / flashcards.length;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 66, 72, 116),
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('${currentIndex + 1}/${flashcards.length}'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: openSettings,
              ),
            ],
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
            color: const Color.fromARGB(255, 66, 72, 116),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipOval(
                        child: FractionallySizedBox(
                          alignment: Alignment.topCenter,
                          widthFactor: 0.5,
                          child: Container(
                            color: Colors.redAccent,
                            child: Center(child: Text('$notKnownCount')),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipOval(
                        child: FractionallySizedBox(
                          alignment: Alignment.topCenter,
                          widthFactor: 0.5,
                          child: Container(
                            color: Colors.greenAccent,
                            child: Center(child: Text('$knownCount')),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.63),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (currentIndex > 0) {
                          controller.unswipe();
                        }
                      }, // Use U-turn icon
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Icon(
                        Icons.reply,
                        size: 35,
                      ),
                    ),
                    TextButton(
                      onPressed: restartFlashcards,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Icon(
                        Icons.replay,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Center(
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _currentSwipeOffset = details.localPosition - _startSwipeOffset;
              });
              print(_currentSwipeOffset);
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.63,
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.height * 0.05,
                  bottom: MediaQuery.of(context).size.height * 0.05,
                ),
                child: AppinioSwiper(
                  invertAngleOnBottomDrag: true,
                  backgroundCardCount: 0,
                  controller: controller,
                  onSwipeEnd: _swipeEnd,
                  onEnd: () {
                    Navigator.pushNamed(context, '/result');
                  },
                  cardCount: flashcards.length,
                  cardBuilder: (BuildContext context, currentIndex) {
                    return Card(
                      color: Colors.transparent,
                      child: FlipCard(
                        key: Key('flip$currentIndex'),
                        front: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: _currentSwipeOffset.dx > 0
                                  ? Colors.green
                                  : (_currentSwipeOffset.dx < 0
                                      ? Colors.red
                                      : Colors.transparent),
                              width: 3.0, // Set border width
                            ),
                            borderRadius: BorderRadius.circular(
                                20.0), // Set border radius
                          ),
                          child: Center(
                            // Center the text
                            child: Text(
                              flashcards[currentIndex].question,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold, // Make the text bold
                                fontSize: 24, // Increase the font size
                              ),
                            ),
                          ),
                        ),
                        back: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: _currentSwipeOffset.dx > 0
                                  ? Colors.green
                                  : (_currentSwipeOffset.dx < 0
                                      ? Colors.red
                                      : Colors.transparent),
                              width: 3.0, // Set border width
                            ),
                            borderRadius: BorderRadius.circular(
                                20.0), // Set border radius
                          ),
                          child: Center(
                            // Center the text
                            child: Text(
                              flashcards[currentIndex].answer,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold, // Make the text bold
                                fontSize: 24, // Increase the font size
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
