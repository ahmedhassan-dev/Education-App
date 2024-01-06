import 'package:education_app/controllers/database_controller.dart';
import 'package:education_app/models/courses_model.dart';
import 'package:education_app/views/widgets/courses_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<CoursesModel>>(
            stream: database.courseListStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final courseList = snapshot.data;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        Text(
                          'Courses',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                        ),
                        const SizedBox(height: 16.0),
                        if (courseList == null || courseList.isEmpty)
                          Center(
                            child: Text(
                              'No Data Available!',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        if (courseList != null && courseList.isNotEmpty)
                          ListView.builder(
                            itemCount: courseList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int i) {
                              final courseType = courseList[i];
                              return CoursesList(
                                courseList: courseType,
                              );
                            },
                          ),
                        const SizedBox(height: 24.0),
                      ],
                    ),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
