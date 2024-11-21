import 'package:education_app/core/helpers/spacing.dart';
import 'package:education_app/core/theming/styles.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/authentication/data/models/student.dart';
import 'package:education_app/features/teacher/check_answers/presentation/manger/fetch_student_data_cubit/fetch_student_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/snackbar.dart';

class CheckAnswersAppBar extends StatelessWidget {
  final BuildContext context;
  const CheckAnswersAppBar({
    super.key,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchStudentDataCubit, FetchStudentDataState>(
      builder: (context, state) {
        if (state is StudentDataLoaded) {
          Student student = (state).student;
          return AppBar(
            title: Text(
              student.userName ?? "",
              style: Styles.bodyLarge16,
            ),
            actions: [
              Text(
                "Total Score: ${student.totalScore}",
                style: Styles.bodyLarge16.copyWith(fontWeight: FontWeight.w600),
              ),
              horizontalSpace(5),
            ],
          );
        } else if (state is StudentDataFailure) {
          showSnackBar(context, state.errorMsg);
        }
        return const ShowLoadingIndicator();
      },
    );
  }
}
