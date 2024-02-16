import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:education_app/business_logic/problems_cubit/problems_cubit.dart';
import 'package:education_app/business_logic/teacher_cubit/teacher_cubit.dart';
import 'package:education_app/data/models/problems.dart';
import 'package:education_app/presentation/widgets/main_button.dart';
import 'package:education_app/presentation/widgets/main_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  void initState() {
    super.initState();
    BlocProvider.of<ProblemsCubit>(context)
        .retrieveSubjectProblems(forTeachers: true);
  }

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

  Future<void> saveProblem() async {
    try {
      if (_formKey.currentState!.validate()) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: 'Nice Answer😊!',
          desc: 'Keep Going❤️',
          dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
        ).show();
        final problem = Problems(
          id: BlocProvider.of<ProblemsCubit>(context)
              .generateNewProblemId(), // TODO: I have to check that it will not be empty or nullable
          problemId: "10",
          title: _titleController.text.trim(),
          problem: _problemController.text.trim(),
          solution: _solutionController.text.trim(),
          stage: _stageController.text.trim(),
          author: _authorController.text.trim(),
          scoreNum: int.parse(_scoreNumController.text.trim()),
          time: int.parse(_timeController.text.trim()),
          needReview: true, //-----> check box
          topics: [_topicsController.text.trim()],
          videos: [_videosController.text.trim()],
        );
        BlocProvider.of<TeacherCubit>(context).storeNewProblem(problem);
        await Future.delayed(const Duration(seconds: 1), () {});
        if (!mounted) return;
        Navigator.of(context).pop();
      }
    } catch (e) {
      MainDialog(
              context: context,
              title: 'Error Saving Problem',
              content: e.toString())
          .showAlertDialog();
    }
  }

  Widget buildBlocWidget() {
    return BlocBuilder<ProblemsCubit, ProblemsState>(
      builder: (context, state) {
        if (state is ProblemsLoaded) {
          return addNewProblemWidget();
        } else {
          return showLoadingIndicator();
        }
      },
    );
  }

  Widget addNewProblemWidget() {
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
                BlocBuilder<TeacherCubit, TeacherState>(
                  builder: (context, state) {
                    return MainButton(
                      text: 'Save Problem',
                      onTap: () => saveProblem(),
                      hasCircularBorder: true,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return addNewProblemWidget();
  }
}
