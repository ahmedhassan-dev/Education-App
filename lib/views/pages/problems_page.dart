import 'package:education_app/views/widgets/problem_timer.dart';
import 'package:flutter/material.dart';

class ProblemPage extends StatefulWidget {
  const ProblemPage({super.key});

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: ProblemTimer()));
  }
}
