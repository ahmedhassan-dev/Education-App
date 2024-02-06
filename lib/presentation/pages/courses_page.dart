import 'package:education_app/business_logic/auth_cubit/auth_cubit.dart';
import 'package:education_app/controllers/database_controller.dart';
import 'package:education_app/data/models/courses_model.dart';
import 'package:education_app/presentation/widgets/courses_list.dart';
import 'package:education_app/utilities/routes.dart';
import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  AuthCubit authCubit = AuthCubit();
  Future<void> _logout(context) async {
    try {
      await authCubit.logOut();
      Navigator.of(context).pushReplacementNamed(AppRoutes.loginPageRoute);
    } catch (e) {
      debugPrint('logout error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            onPressed: () {
              _logout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
        toolbarHeight: 60,
      ),
      body: const SafeArea(
        child: SizedBox(),
        // child: StreamBuilder<List<CoursesModel>>(
        //     stream: database.courseListStream(),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.active) {
        //         final courseList = snapshot.data;

        //         return SingleChildScrollView(
        //           child: Padding(
        //             padding: const EdgeInsets.symmetric(
        //                 vertical: 8.0, horizontal: 16.0),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 if (courseList == null || courseList.isEmpty)
        //                   Center(
        //                     child: Text(
        //                       'No Data Available!',
        //                       style: Theme.of(context).textTheme.titleMedium,
        //                     ),
        //                   ),
        //                 if (courseList != null && courseList.isNotEmpty)
        //                   ListView.builder(
        //                     itemCount: courseList.length,
        //                     shrinkWrap: true,
        //                     physics: const NeverScrollableScrollPhysics(),
        //                     itemBuilder: (BuildContext context, int i) {
        //                       final courseType = courseList[i];
        //                       return CoursesList(
        //                         courseList: courseType,
        //                       );
        //                     },
        //                   ),
        //                 const SizedBox(height: 24.0),
        //               ],
        //             ),
        //           ),
        //         );
        //       }
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }),
      ),
    );
  }
}
