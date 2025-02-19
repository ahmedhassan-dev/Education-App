import 'package:education_app/core/widgets/awesome_dialog.dart';
import 'package:education_app/core/widgets/loading_overlay.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/core/widgets/snackbar.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/teacher/add_new_problem/logic/add_new_problem_cubit.dart';
import 'package:education_app/features/problems/data/models/problems.dart';
import 'package:education_app/core/widgets/main_button.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/widgets/get_list_of_strings_text.dart';
import 'package:education_app/features/teacher/add_new_problem/ui/course_problems_modal_bottom_sheet.dart';
import 'package:education_app/features/teacher/add_new_problem/ui/widgets/text_form_field_with_add_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AddNewProblemPage extends StatefulWidget {
  final Courses course;
  const AddNewProblemPage({super.key, required this.course});

  @override
  State<AddNewProblemPage> createState() => _AddNewProblemPageState();
}

class _AddNewProblemPageState extends State<AddNewProblemPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _problemController = TextEditingController();
  final _solutionController = TextEditingController();
  final _scoreNumController = TextEditingController();
  final _timeController = TextEditingController();
  final _topicsController = TextEditingController();
  final _videosController = TextEditingController();
  bool reviewManuallyCheckBox = false;
  List<String> topicsList = [];
  List<String> videosList = [];
  final LoadingOverlay _loadingOverlay = LoadingOverlay();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AddNewProblemCubit>(context)
        .getTeacherDataFromSharedPreferences();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _problemController.dispose();
    _solutionController.dispose();
    _scoreNumController.dispose();
    _timeController.dispose();
    _topicsController.dispose();
    _videosController.dispose();
    super.dispose();
  }

  Future<void> saveProblem() async {
    try {
      if (_videosController.text.trim().isNotEmpty) {
        convertUrlToId(); //TODO: Have to stop submission if the URL is not valid
      }
      if (_formKey.currentState!.validate()) {
        keepGoingAwesomeDialog(context, title: 'Problem Saved😊!').show();
        storeNewProblem();
      }
    } catch (e) {
      errorAwesomeDialog(context, e).show();
    }
  }

  Widget buildBlocWidget() {
    return BlocConsumer<AddNewProblemCubit, AddNewProblemState>(
        listener: (BuildContext context, AddNewProblemState state) async {
      if (state is ProblemStored) {
        resetAllControllers();
        final navigator = Navigator.of(context);
        await Future.delayed(const Duration(seconds: 1), () {});
        navigator.pop();
      } else if (state is LoadingModalBottomSheetData) {
        _loadingOverlay.show(context);
      } else if (state is ModalBottomSheetProblemsLoaded) {
        _loadingOverlay.hide();
        showProblemsModel(context, problemsList: state.problemsList);
      } else if (state is ErrorOccurred) {
        errorAwesomeDialog(context, state.errorMsg).show();
      }
    }, builder: (context, AddNewProblemState state) {
      if (state is Loading) {
        return const ShowLoadingIndicator();
      } else {
        return addNewProblemWidget();
      }
    });
  }

  void resetAllControllers() {
    _titleController.text = "";
    _problemController.text = "";
    _solutionController.text = "";
    _scoreNumController.text = "";
    _timeController.text = "";
    _topicsController.text = "";
    _videosController.text = "";
    topicsList = [];
    videosList = [];
  }

  Future<void> storeNewProblem() async {
    if (_topicsController.text.trim().isNotEmpty) {
      topicsList.add(_topicsController.text.trim());
    }
    topicsList.add(widget.course.subject);
    final problem = Problems(
      globalProblemId: 0,
      problemId: 0,
      courseId: widget.course.id,
      title: _titleController.text.trim(),
      problem: _problemController.text.trim(),
      solutions: [_solutionController.text.trim()],
      stage: widget.course.stage,
      authorEmail: context.read<AddNewProblemCubit>().email,
      authorName: context.read<AddNewProblemCubit>().userName,
      scoreNum: int.parse(_scoreNumController.text.trim()),
      time: int.parse(_timeController.text.trim()),
      needReview: reviewManuallyCheckBox,
      topics: topicsList,
      videos: videosList,
    );
    BlocProvider.of<AddNewProblemCubit>(context)
        .saveNewProblem(problem: problem);
  }

  Widget addNewProblemWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adding New Problem",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        toolbarHeight: 50.h,
        actions: [
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<AddNewProblemCubit>(context)
                  .getCourseProblems(widget.course);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 13),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            child: const Text(
              'My Problems',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                GetListOfStringsText(stringList: topicsList),
                TextFormFieldWithAddButton(
                    controller: _topicsController,
                    labelText: 'Topics',
                    stringList: topicsList,
                    onTap: () {
                      if (_topicsController.text.trim().isNotEmpty) {
                        topicsList.add(_topicsController.text.trim());
                        _topicsController.text = "";
                        setState(() {});
                      }
                    }),
                const SizedBox(height: 16.0),
                GetListOfStringsText(stringList: videosList),
                TextFormFieldWithAddButton(
                    controller: _videosController,
                    labelText: 'Explanation Link',
                    stringList: videosList,
                    onTap: () {
                      if (_videosController.text.trim().isNotEmpty) {
                        convertUrlToId();
                      }
                    }),
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

  void convertUrlToId() {
    String? videoId =
        YoutubePlayer.convertUrlToId(_videosController.text.trim());
    if (videoId != null) {
      videosList.add(videoId);
    } else {
      showSnackBar(context, "Please enter a valid URL");
    }
    _videosController.text = "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget();
  }
}
