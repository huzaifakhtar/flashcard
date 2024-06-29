import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final List<Map<String, String>> flashcards = [
    {'question': 'Who developed Flutter?', 'answer': 'Google'},
    {'question': 'What language does Flutter use?', 'answer': 'Dart'},
    {
      'question': 'What is Flutter?',
      'answer':
          'A UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.'
    },
    {'question': 'Who developed Flutter?', 'answer': 'Google'},
    {'question': 'What language does Flutter use?', 'answer': 'Dart'},
    {
      'question': 'What is Flutter?',
      'answer':
          'A UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.'
    }
  ];
  int currentIndex = 0;
  int leftSwipeCount = 0;
  int rightSwipeCount = 0;
  List<bool> swipeHistory = [];

  void _incrementSwipeCount(bool isRightSwipe) {
    setState(() {
      swipeHistory.add(isRightSwipe);
      if (isRightSwipe) {
        rightSwipeCount++;
      } else {
        leftSwipeCount++;
      }
      currentIndex = (currentIndex + 1) % flashcards.length;
    });
  }

  void _undoLastSwipe() {
    setState(() {
      if (swipeHistory.isNotEmpty) {
        bool lastSwipe = swipeHistory.removeLast();
        if (lastSwipe) {
          rightSwipeCount--;
        } else {
          leftSwipeCount--;
        }
        currentIndex = (currentIndex - 1 + flashcards.length) % flashcards.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / flashcards.length;
    return Stack(
      children: [
    Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 26, 57),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${currentIndex + 1}/${flashcards.length}'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                  children: [ 
                    Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromRGBO(249, 168, 37, 1),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$leftSwipeCount',
                        style: const TextStyle(
                            color: Color.fromRGBO(249, 168, 37, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ],
                  ),
                  Stack(
                  children: [ 
                    Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.greenAccent,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$rightSwipeCount',
                        style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 13, 26, 57),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 550), // Space above the flashcard
                  ElevatedButton(
                    onPressed: _undoLastSwipe,
                    child: const Text('Undo'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50), // Space above the flashcard
                  DraggableFlashCard(
                    key: ValueKey(currentIndex),
                    flashcard: flashcards[currentIndex],
                    onSwiped: _incrementSwipeCount,
                  ),
                ],
              ),
            ),
    ],
    );
  }
}

class DraggableFlashCard extends StatefulWidget {
  final Map<String, String> flashcard;
  final ValueChanged<bool> onSwiped; // Updated to pass swipe direction
  const DraggableFlashCard(
      {super.key, required this.flashcard, required this.onSwiped});

  @override
  // ignore: library_private_types_in_public_api
  _DraggableFlashCardState createState() => _DraggableFlashCardState();
}

class _DraggableFlashCardState extends State<DraggableFlashCard>
    with SingleTickerProviderStateMixin {
  Offset offset = Offset.zero;
  bool isDragging = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePanEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (offset.dx.abs() > screenWidth * 0.25) {
      _animateCard(offset.dx > 0 ? screenWidth : -screenWidth);
    } else {
      setState(() {
        offset = Offset.zero;
        isDragging = false;
      });
    }
  }

  void _animateCard(double endX) {
    _animation = Tween<Offset>(begin: offset, end: Offset(endX, offset.dy))
        .animate(_controller)
      ..addListener(() => setState(() => offset = _animation.value));
    _controller.forward().then((_) {
      widget.onSwiped(endX > 0); // Pass swipe direction
      _controller.reset();
      setState(() {
        offset = Offset.zero;
        isDragging = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double opacity = (offset.dx.abs() / 70).clamp(0.0, 1.0);
    Color? borderColor = isDragging
        ? (offset.dx > 0 ? Colors.greenAccent : Colors.yellow[800])
        : Colors.transparent;
    String overlayText = offset.dx > 0 ? 'Know' : 'Still Learning';

    return GestureDetector(
      onPanStart: (_) => setState(() => isDragging = true),
      onPanUpdate: (details) => setState(() => offset += details.delta),
      onPanEnd: _handlePanEnd,
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: offset.dx / 600,
          child: Center(
          child: Container(
            width: 350,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: borderColor!.withOpacity(opacity), width: 5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FlipCard(
              key: Key('flip${widget.key}'),
              front: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color:  const Color.fromARGB(255, 84, 93, 141), // Background color for the flip card
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        widget.flashcard['question']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: opacity,
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 84, 93,
                              141), // Background color for the flip card
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        // Set your desired background color here
                        child: Text(
                          overlayText,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: offset.dx > 0
                                  ? Colors.greenAccent
                                  : Colors.yellow[800]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              back: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 84, 93,
                            141), // Background color for the flip card
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        widget.flashcard['answer']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: opacity,
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 84, 93,
                              141), // Background color for the flip card
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        // Set your desired background color here
                        child: Text(
                          overlayText,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: offset.dx > 0
                                  ? Colors.greenAccent
                                  : Colors.yellow[800]),
                        ),
                      ),
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
