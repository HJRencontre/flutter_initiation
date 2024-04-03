import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent)
            .copyWith(background: Colors.red),
      ),
      home: const MyHomePage(title: 'F1 reaction test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer = Timer(Duration.zero, () {});
  Color _backgroundColor = Colors.white;
  bool _isGameRunning = false;
  bool _isFalseStart = false;
  late double _score = 0.0;
  Timer? _delayedStart;


  void _startGame() {
    var random = Random();
    var delay = random.nextInt(5) + 1;

    _resetGame();

    setState(() {
      _isGameRunning = true;
      _backgroundColor = Colors.red;
    });

    _delayedStart = Timer(Duration(seconds: delay), () { // Update this line
      launchTimer();
    });
  }

  void launchTimer() {
    _stopwatch.start();
    setState(() {
      _backgroundColor = Colors.green;
      _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
        setState(() {}); // force refresh
      });
    });
  }

  void _stopGame() {
    if (_delayedStart?.isActive ?? false) {
      _isFalseStart = true;
    }
    _delayedStart?.cancel();
    _stopwatch.stop();
    _timer.cancel();
    _score = _stopwatch.elapsedMilliseconds / 1000.0;
    setState(() {
      _backgroundColor = Colors.white;
      _isGameRunning = false;
    });
  }

  void _resetGame() {
    setState(() {
      _timer = Timer(Duration.zero, () {});
      _stopwatch.reset();
      _isFalseStart = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Press the button as fast as you can!',
            ),
            const Text(
              'Score:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              !_isFalseStart ? '${_stopwatch.elapsedMilliseconds / 1000.0}s' : 'FALSE START',
              style: const TextStyle(fontSize: 24),
            ),
            FloatingActionButton.large(
              onPressed: () {
                if (_isGameRunning) {
                  _stopGame();
                } else {
                  _startGame();
                }
              },
              child: _isGameRunning
                  ? const Icon(Icons.stop)
                  : const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}
