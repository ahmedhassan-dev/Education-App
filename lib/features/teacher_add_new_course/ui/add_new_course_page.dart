import 'package:education_app/core/constants/constants.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/core/widgets/awesome_dialog.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/core/widgets/snackbar.dart';
import 'package:education_app/features/teacher_add_new_course/logic/add_new_course_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:education_app/core/constants/stages.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/widgets/get_list_of_strings_text.dart';
import 'package:education_app/core/widgets/main_button.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/teacher/add_new_problem/ui/widgets/text_form_field_with_add_button.dart';
import 'package:education_app/features/teacher_add_new_course/ui/widgets/drop_down_menu.dart';

class AddNewCoursePage extends StatefulWidget {
  final String subject;
  const AddNewCoursePage({
    super.key,
    required this.subject,
  });
  @override
  State<AddNewCoursePage> createState() => _AddNewCoursePageState();
}

class _AddNewCoursePageState extends State<AddNewCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _topicsController = TextEditingController();
  String? stage;
  List<String> topicsList = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AddNewCourseCubit>(context)
        .getTeacherDataFromSharedPreferences();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _topicsController.dispose();
    super.dispose();
  }

  Future<void> saveCourse() async {
    if (stage == null) {
      showSnackBar(context, "Please choose the educational stage");
    } else if (_formKey.currentState!.validate()) {
      keepGoingAwesomeDialog(context, title: 'Data Saved😊!').show();
      storeNewCourse();
    }
  }

  Widget buildBlocWidget() {
    return BlocConsumer<AddNewCourseCubit, AddNewCourseState>(
        listener: (BuildContext context, AddNewCourseState state) async {
      if (state is CourseDataStored) {
        await Future.delayed(const Duration(seconds: 1), () {});
        if (!mounted) return;
        Navigator.popUntil(context,
            ModalRoute.withName(AppRoutes.teacherSubjectsDetailsRoute));
        if (context.read<AddNewCourseCubit>().subjects!.length == 1) {
          Navigator.of(context).pushNamed(AppRoutes.teacherSubjectsDetailsRoute,
              arguments: widget.subject);
        } else {
          Navigator.of(context).pushReplacementNamed(
              AppRoutes.teacherSubjectsDetailsRoute,
              arguments: widget.subject);
        }
      } else if (state is ErrorOccurred) {
        errorAwesomeDialog(context, state.errorMsg,
                title: 'Error Storing Course Data')
            .show();
      }
    }, builder: (context, AddNewCourseState state) {
      if (state is Loading) {
        return const ShowLoadingIndicator();
      } else {
        return addNewCourseWidget();
      }
    });
  }

  Future<void> storeNewCourse() async {
    if (_topicsController.text.trim().isNotEmpty) {
      topicsList.add(_topicsController.text.trim());
    }
    final Courses course = Courses(
      id: documentIdFromLocalData(),
      stage: stage!,
      authorEmail: context.read<AddNewCourseCubit>().email!,
      authorName: context.read<AddNewCourseCubit>().userName!,
      topics: topicsList,
      imgUrl: '',
      subject: widget.subject,
      description: _descriptionController.text.trim(),
    );
    BlocProvider.of<AddNewCourseCubit>(context).saveNewCourse(course: course);
  }

  Widget addNewCourseWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Adding New Course",
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  height: 65.h,
                  child: DropDownMenuComponent(
                    items: EducationalStages.educationalStages,
                    hint: 'Stage',
                    onChanged: (String? newValue) {
                      stage = newValue!;
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    fillColor: AppColors.textFormFieldFillColor,
                    filled: true,
                  ),
                  validator: (value) => value!.isNotEmpty
                      ? null
                      : 'Please enter the course description',
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
                MainButton(
                  text: 'Create Course',
                  onTap: () {
                    saveCourse();
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

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget();
  }
}
