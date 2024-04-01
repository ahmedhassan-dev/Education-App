import 'package:education_app/core/theming/styles.dart';
import 'package:flutter/material.dart';

class NoAnswersAvailablePage extends StatelessWidget {
  const NoAnswersAvailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "❤️No Answers Available❤️",
          style: Styles.titleLarge22,
        ),
      ),
    );
  }
}
