import 'package:education_app/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _problemController = TextEditingController();
  final _solutionController = TextEditingController();
  final _stageController = TextEditingController();
  final _authorController = TextEditingController();
  final _scoreNumController = TextEditingController();
  final _timeController = TextEditingController();
  final _topicsController = TextEditingController();
  final _videosController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _problemController.dispose();
    _solutionController.dispose();
    _stageController.dispose();
    _authorController.dispose();
    _scoreNumController.dispose();
    _timeController.dispose();
    _topicsController.dispose();
    _videosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Adding New Problem",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) =>
                      value!.isNotEmpty ? null : 'Please enter the title',
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _problemController,
                  decoration: const InputDecoration(
                    labelText: 'Problem',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) =>
                      value!.isNotEmpty ? null : 'Please enter a problem',
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _solutionController,
                  decoration: const InputDecoration(
                    labelText: 'Solution',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) =>
                      value!.isNotEmpty ? null : 'Please enter the solution',
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _scoreNumController,
                  decoration: const InputDecoration(
                    labelText: 'Score Numbers',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) => value!.isNotEmpty
                      ? null
                      : 'Please enter the score numbers',
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: 'Expected Time',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) => value!.isNotEmpty
                      ? null
                      : 'Please enter the expected time',
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _stageController,
                  decoration: const InputDecoration(
                    labelText: 'Stage',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) =>
                      value!.isNotEmpty ? null : 'Please enter your the stage',
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _topicsController,
                  decoration: const InputDecoration(
                    labelText: 'Topics',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) =>
                      value!.isNotEmpty ? null : 'Please enter your any topic',
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _videosController,
                  decoration: const InputDecoration(
                    labelText: 'Explanation Link',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) => value!.isNotEmpty
                      ? null
                      : 'Please enter your the explanation link',
                ),
                const SizedBox(height: 32.0),
                MainButton(
                  text: 'Save Problem',
                  onTap: () => saveProblem(),
                  hasCircularBorder: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
