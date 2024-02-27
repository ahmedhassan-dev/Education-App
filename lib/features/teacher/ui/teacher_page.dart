import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:education_app/features/teacher/logic/teacher_cubit.dart';
import 'package:education_app/features/problems/data/models/problems.dart';
import 'package:education_app/core/widgets/main_button.dart';
import 'package:education_app/features/onboarding/widgets/need_update.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/features/teacher/ui/widgets/text_form_field_with_add_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final _scoreNumController = TextEditingController();
  final _timeController = TextEditingController();
  final _topicsController = TextEditingController();
  final _videosController = TextEditingController();
  bool reviewManuallyCheckBox = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TeacherCubit>(context).checkForUpdates();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _problemController.dispose();
    _solutionController.dispose();
    _stageController.dispose();
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
          title: 'Problem Saved😊!',
          desc: 'Keep Going❤️',
          dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
        ).show();
        storeNewProblem();
      }
    } catch (e) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.scale,
              title: 'Error Generating New Id',
              desc: e.toString(),
              dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1))
          .show();
    }
  }

  Widget buildBlocWidget() {
    return BlocConsumer<TeacherCubit, TeacherState>(
        listener: (BuildContext context, TeacherState state) async {
      if (state is ProblemStored) {
        resetAllControllers();
        await Future.delayed(const Duration(seconds: 1), () {});
        if (!mounted) return;
        Navigator.pop(context);
      }
    }, builder: (context, TeacherState state) {
      if (state is NeedUpdate) {
        return const NeedToUpdate();
      } else if (state is UserEmailRetrieved || state is ProblemStored) {
        return addNewProblemWidget();
      } else {
        return showLoadingIndicator();
      }
    });
  }

  void resetAllControllers() {
    _titleController.text = "";
    _problemController.text = "";
    _solutionController.text = "";
    _stageController.text = "";
    _scoreNumController.text = "";
    _timeController.text = "";
    _topicsController.text = "";
    _videosController.text = "";
  }

  Future<void> storeNewProblem() async {
    final problem = Problems(
      id: null, // TODO: I have to check that it will not be empty or nullable
      problemId: null,
      title: _titleController.text.trim(),
      problem: _problemController.text.trim(),
      solution: _solutionController.text.trim(),
      stage: _stageController.text.trim(),
      author: context.read<TeacherCubit>().email,
      scoreNum: int.parse(_scoreNumController.text.trim()),
      time: int.parse(_timeController.text.trim()),
      needReview: reviewManuallyCheckBox,
      topics: [_topicsController.text.trim()],
      videos: [_videosController.text.trim()],
    );
    BlocProvider.of<TeacherCubit>(context).saveNewProblem(problem: problem);
  }

  Widget addNewProblemWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Adding New Problem",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    fillColor: AppColors.textFormFieldFillColor,
                    filled: true,
                  ),
                  validator: (value) =>
                      value!.isNotEmpty ? null : 'Please enter the title',
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _problemController,
                  decoration: InputDecoration(
                    labelText: 'Problem',
                    fillColor: AppColors.textFormFieldFillColor,
                    filled: true,
                  ),
                  validator: (value) =>
                      value!.isNotEmpty ? null : 'Please enter a problem',
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _solutionController,
                  decoration: InputDecoration(
                    labelText: 'Solution',
                    fillColor: AppColors.textFormFieldFillColor,
                    filled: true,
                  ),
                  validator: (value) =>
                      value!.isNotEmpty ? null : 'Please enter the solution',
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _scoreNumController,
                  decoration: InputDecoration(
                    labelText: 'Score Numbers',
                    fillColor: AppColors.textFormFieldFillColor,
                    filled: true,
                  ),
                  validator: (value) => value!.isNotEmpty
                      ? null
                      : 'Please enter the score numbers',
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: 'Expected Time',
                    fillColor: AppColors.textFormFieldFillColor,
                    filled: true,
                  ),
                  validator: (value) => value!.isNotEmpty
                      ? null
                      : 'Please enter the expected time',
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _stageController,
                  decoration: InputDecoration(
                    labelText: 'Stage',
                    fillColor: AppColors.textFormFieldFillColor,
                    filled: true,
                  ),
                  validator: (value) =>
                      value!.isNotEmpty ? null : 'Please enter your stage',
                ),
                const SizedBox(height: 16.0),
                TextFormFieldWithAddButton(
                    controller: _topicsController,
                    labelText: 'Topics',
                    onTap: () {}),
                const SizedBox(height: 16.0),
                TextFormFieldWithAddButton(
                    controller: _videosController,
                    labelText: 'Explanation Link',
                    onTap: () {}),
                Row(
                  children: [
                    Checkbox(
                        activeColor: AppColors.primaryColor,
                        side: BorderSide(color: AppColors.whiteColor),
                        value: reviewManuallyCheckBox,
                        onChanged: (val) => setState(() {
                              reviewManuallyCheckBox = val!;
                            })),
                    Text(
                      "Review manually",
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  ],
                ),
                const SizedBox(height: 7.0),
                MainButton(
                  text: 'Save Problem',
                  onTap: () {
                    saveProblem();
                  },
                  hasCircularBorder: true,
                )
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
    return buildBlocWidget();
  }
}
