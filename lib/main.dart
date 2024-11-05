import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:gym_counter/component/StyledButton.dart';
import 'package:gym_counter/component/StyledText.dart';
import 'package:gym_counter/const/Colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym Counter',
      home: DefaultTabController(
        length: 2,
        child: MyHomePage(title: 'Gym Counter'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isStarted = false;
  bool _isResting = false;
  bool _isPaused = false;
  int _allDurationWorkout = 0;
  int _durationToRest = 0;
  String _restType = '';
  final AudioPlayer _audioPlayer = AudioPlayer();

  DateTime? _startTime;
  DateTime? _restStartTime;

  Timer? _workoutTimer;
  Timer? _restTimer;

  void startWorkoutTimer() {
    setState(() {
      isStarted = true;
      _startTime = DateTime.now();
    });

    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _allDurationWorkout =
              DateTime.now().difference(_startTime!).inSeconds;
        });
      }
    });
  }

  void calculateRestTime(int durationOfRest) {
    _restStartTime = DateTime.now();
    setState(() {
      _isResting = true;
      _durationToRest = durationOfRest;
      _restType = durationOfRest == 60
          ? 'Leve'
          : durationOfRest == 90
              ? 'Médio'
              : 'Pesado';
    });

    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final elapsedRestTime =
            DateTime.now().difference(_restStartTime!).inSeconds;
        _durationToRest = durationOfRest - elapsedRestTime;
        if (_durationToRest <= 0) {
          _playSoundAndResetRestingState();
          _restTimer?.cancel();
        }
      });
    });
  }

  void _playSoundAndResetRestingState() async {
    await _audioPlayer.play(AssetSource('sounds/output.mp3'));
    setState(() {
      _isResting = false;
      _restType = '';
      _durationToRest = 0;
    });
  }

  void pauseTimer() {
    setState(() {
      _isPaused = true;
    });
  }

  void resumeTimer() {
    setState(() {
      _isPaused = false;
      _startTime =
          DateTime.now().subtract(Duration(seconds: _allDurationWorkout));
    });
  }

  @override
  void dispose() {
    _workoutTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  String formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '${hours > 0 ? '$hours h ' : ''}${minutes > 0 ? '$minutes min ' : ''}$seconds seg ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: StyledText(
          text: widget.title,
          size: 30,
        ),
      ),
      body: TabBarView(
        children: [
          counterView(),
          const Center(
            child: StyledText(text: "incoming"),
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: TabBar(
          indicator: const UnderlineTabIndicator(
              insets: EdgeInsets.symmetric(horizontal: 80.0)),
          labelColor: StyledColors.primaryColor(),
          unselectedLabelColor: Colors.grey,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(
              icon: Icon(Icons.fitness_center),
            ),
            Tab(
              icon: Icon(Icons.article),
            ),
          ],
        ),
      ),
    );
  }

  Widget counterView() {
    return Center(
      child: Column(
        children: <Widget>[
          const StyledText(
            text: "Tempo total de treino",
            size: 25,
          ),
          const SizedBox(height: 10),
          Container(
            width: 300,
            height: 50,
            decoration: BoxDecoration(
              border:
                  Border.all(width: 0.5, color: StyledColors.primaryColor()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: StyledText(
                text: formatDuration(_allDurationWorkout),
                size: 20,
              ),
            ),
          ),
          if (!isStarted) const SizedBox(height: 20),
          StyledButton('Iniciar treino', () {
            startWorkoutTimer();
          }, _isResting),
          Column(
            children: _isResting
                ? [
                    const StyledText(
                      text: 'Tempo de descanso: ',
                      size: 26,
                    ),
                    const SizedBox(height: 10),
                    StyledText(
                      text: 'Descanso $_restType por: ',
                      size: 22,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5, color: StyledColors.primaryColor()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: StyledText(
                          text: formatDuration(_durationToRest),
                          size: 20,
                        ),
                      ),
                    ),
                  ]
                : [],
          ),
          Column(
            children: [
              if (isStarted && !_isResting) ...[
                const SizedBox(height: 90),
                StyledButton("Descanso leve 60s", () => calculateRestTime(60),
                    _isResting),
                const SizedBox(height: 20),
                StyledButton("Descanso Médio 1m 30s",
                    () => calculateRestTime(90), _isResting),
                const SizedBox(height: 20),
                StyledButton("Descanso Pesado 3m", () => calculateRestTime(180),
                    _isResting),
              ],
            ],
          )
        ],
      ),
    );
  }
}
