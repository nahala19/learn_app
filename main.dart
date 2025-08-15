// main.dart
import 'dart:async'; // For the Timer class.
import 'package:flutter/material.dart';

void main() {
  // The main entry point for a Flutter application.
  runApp(const LearnAndTellApp());
}

// The root widget of the application.
// We use a StatelessWidget as the root since the overall app structure is static.
class LearnAndTellApp extends StatelessWidget {
  const LearnAndTellApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp provides many useful features for a material design app.
    return MaterialApp(
      title: '5-Minute Learn & Tell',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Set the font to Inter for a clean, modern look.
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const LearnAndTellHomePage(),
      debugShowCheckedModeBanner: false, // Hides the debug banner.
    );
  }
}

// A StatefulWidget to manage the state of the timer and user input.
// This is necessary because the timer value changes over time.
class LearnAndTellHomePage extends StatefulWidget {
  const LearnAndTellHomePage({super.key});

  @override
  State<LearnAndTellHomePage> createState() => _LearnAndTellHomePageState();
}

// The State class for the LearnAndTellHomePage.
// This is where the core logic and mutable state for the app resides.
class _LearnAndTellHomePageState extends State<LearnAndTellHomePage> {
  // Total duration for the timer, 5 minutes.
  static const int _totalSeconds = 5 * 60;
  
  // The current number of seconds remaining.
  int _secondsRemaining = _totalSeconds;

  // The timer object itself. It's nullable because it might not be active.
  Timer? _timer;

  // A controller for the text input field.
  final TextEditingController _learningController = TextEditingController();

  // A list to store the facts the user has learned.
  final List<String> _learnedFacts = [];

  // A flag to check if the timer is currently running.
  bool _isTimerRunning = false;

  // This method is called when the widget is first inserted into the widget tree.
  @override
  void initState() {
    super.initState();
    // Start the timer automatically when the app loads.
    _startTimer();
  }

  // Starts the countdown timer.
  void _startTimer() {
    // If the timer is already running, do nothing.
    if (_isTimerRunning) return;

    // Reset the seconds and set the flag.
    setState(() {
      _secondsRemaining = _totalSeconds;
      _isTimerRunning = true;
    });

    // Create a periodic timer that ticks every second.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          // If the timer reaches zero, stop it.
          _stopTimer();
        }
      });
    });
  }

  // Stops the timer and sets the running flag to false.
  void _stopTimer() {
    _timer?.cancel(); // The ?. operator safely calls cancel() if the timer is not null.
    setState(() {
      _isTimerRunning = false;
    });
  }

  // Resets the timer to its initial state.
  void _resetTimer() {
    _stopTimer();
    setState(() {
      _secondsRemaining = _totalSeconds;
    });
  }

  // Formats the remaining seconds into a mm:ss string.
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60; // Integer division.
    int remainingSeconds = seconds % 60; // Modulo operator.

    String minutesString = minutes.toString().padLeft(2, '0');
    String secondsString = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesString:$secondsString';
  }

  // This method is called when the user submits a fact.
  void _submitFact() {
    // Get the text from the controller.
    final String fact = _learningController.text.trim();
    // If the text is not empty, add it to the list.
    if (fact.isNotEmpty) {
      setState(() {
        _learnedFacts.add(fact);
      });
      _learningController.clear(); // Clear the text field.
    }
  }

  // This method is called when the widget is disposed of.
  // It's crucial to cancel the timer to prevent memory leaks.
  @override
  void dispose() {
    _timer?.cancel();
    _learningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides a basic app layout.
    return Scaffold(
      appBar: AppBar(
        title: const Text('learning app'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      // Use a SingleChildScrollView to make the content scrollable on smaller screens.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Display the countdown timer.
              Text(
                _formatTime(_secondsRemaining),
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Show a message when the timer is done.
              if (!_isTimerRunning && _secondsRemaining == 0)
                const Text(
                  'Time is up! It\'s time to tell!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              // Buttons for timer control.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isTimerRunning ? null : _startTimer,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.greenAccent;
                        }
                        return Colors.green;
                      }),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isTimerRunning ? _stopTimer : null,
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.deepOrangeAccent;
                        }
                        return Colors.orange;
                      }),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.blueGrey;
                        }
                        return Colors.grey;
                      }),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Text input field for the learned fact.
              const Text(
                'What did you learn?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _learningController,
                decoration: InputDecoration(
                  hintText: 'Type your new fact here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _submitFact,
                    color: Colors.blueAccent,
                    hoverColor: Colors.lightBlue,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onSubmitted: (_) => _submitFact(),
              ),
              const SizedBox(height: 40),
              // Display the list of learned facts.
              const Text(
                'Facts Learned:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              _learnedFacts.isEmpty
                  ? const Text(
                      'No facts submitted yet.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true, // Prevents a layout error with SingleChildScrollView.
                      physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling.
                      itemCount: _learnedFacts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.check_circle, color: Colors.blueAccent),
                            title: Text(_learnedFacts[index]),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
