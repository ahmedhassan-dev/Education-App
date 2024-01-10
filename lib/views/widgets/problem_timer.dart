import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProblemTimer extends StatefulWidget {
  const ProblemTimer({super.key});

  @override
  State<ProblemTimer> createState() => _ProblemTimerState();
}

class _ProblemTimerState extends State<ProblemTimer> {
  Timer? timerFunction;
  Duration duration = const Duration(minutes: 0);

  startTimer() {
    timerFunction = Timer.periodic(const Duration(seconds: 1), (time) {
      if (mounted) {
        setState(() {
          int newSeconds = duration.inSeconds + 1;
          duration = Duration(seconds: newSeconds);
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
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
          // TODO: Will give error if pass 3600
          percent: timerFunction!.tick / 3600,
          animation: true,
          animateFromLastPercent: true,
          animationDuration: 1000,
          radius: 60,
          center: Text(
            "${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}",
            style: TextStyle(fontSize: 39, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
