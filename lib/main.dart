import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  late Timer _timer;
  late Timer _restTime;
  int _allDurationWorkout = 0;
  int _durationToRest = 0;
  bool _isWorkout = false;
  String _restType = '';
  bool _isResting = false;
  bool _isPaused = false;

  void startTimeToWorkout() {
    setState(() {
      _isWorkout = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!_isPaused) {
        setState(() {
          _allDurationWorkout++;
        });
      }
    });
  }

  void calculateRestTime(int durationOfRest) {
    setState(() {
      _isResting = true;
      if (durationOfRest == 40) {
        _restType = 'Leve';
      } else if (durationOfRest == 90) {
        _restType = 'Médio';
      } else if (durationOfRest == 180) {
        _restType = 'Pesado';
      }
      _durationToRest = durationOfRest;
    });

    _restTime = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_durationToRest > 0) {
          _durationToRest--;
        }
        if (_durationToRest == 0) {
          _restTime.cancel();
          setState(() {
            _isResting = false;
          });
        }
      });
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
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _restTime.cancel();
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text(
              'Tempo total de treino: ',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            Text(
              formatDuration(_allDurationWorkout),
              style: const TextStyle(
                  fontSize: 24, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            _isWorkout
                ? const SizedBox(height: 0)
                : ButtonTheme(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isWorkout = true;
                        });
                        startTimeToWorkout();
                      },
                      child: const Text('Iniciar treino'),
                    ),
                  ),
            ButtonTheme(
              child: ElevatedButton(
                onPressed: _isPaused ? resumeTimer : pauseTimer,
                child: Text(_isPaused ? 'Retomar treino' : 'Pausar treino'),
              ),
            ),
            const SizedBox(height: 130),
            const Text(
              'Tempo de descanso: ',
              style:
                  TextStyle(fontSize: 24, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            const SizedBox(height: 10),
            Text(
              'Descanso $_restType por: ',
              style:
                  TextStyle(fontSize: 24, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            Text(
              formatDuration(_durationToRest),
              style: const TextStyle(
                  fontSize: 24, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            ButtonTheme(
              child: ElevatedButton(
                onPressed: _isResting
                    ? null
                    : () {
                        calculateRestTime(40);
                      },
                child: const Text('Descanso Leve 40s'),
              ),
            ),
            ButtonTheme(
              child: ElevatedButton(
                onPressed: _isResting
                    ? null
                    : () {
                        calculateRestTime(90);
                      },
                child: const Text('Descanso Médio 1min e 30s'),
              ),
            ),
            ButtonTheme(
              child: ElevatedButton(
                onPressed: _isResting
                    ? null
                    : () {
                        calculateRestTime(180);
                      },
                child: const Text('Descanso Pesado 3min'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
