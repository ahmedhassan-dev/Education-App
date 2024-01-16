import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProblemTimer extends StatefulWidget {
  final int problemIndex;
  final int expectedTime;
  const ProblemTimer(
      {super.key, required this.problemIndex, required this.expectedTime});

  @override
  State<ProblemTimer> createState() => _ProblemTimerState();
}

class _ProblemTimerState extends State<ProblemTimer> {
  Timer? timerFunction;
  Duration duration = const Duration(minutes: 0);
  int oldIndex = 0;
  startTimer() {
    Timer.periodic(const Duration(seconds: 1), (time) {
      if (mounted) {
        setState(() {
          if (oldIndex != widget.problemIndex) {
            oldIndex = widget.problemIndex;
            duration = const Duration(minutes: 0, seconds: 0);
          }
          int newSeconds = duration.inSeconds + 1;
          duration = Duration(seconds: newSeconds);
        });
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          height: 20,
        ),
        CircularPercentIndicator(
          progressColor: Colors.red,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          lineWidth: 7,
          percent: duration.inSeconds / (widget.expectedTime * 60) <= 1
              ? duration.inSeconds / (widget.expectedTime * 60)
              : 1,
          animation: true,
          animateFromLastPercent: true,
          animationDuration: 1000,
          radius: 60,
          center: Text(
            "${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}",
            style: const TextStyle(fontSize: 39, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
