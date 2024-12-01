import 'package:education_app/core/helpers/context_extension.dart';
import 'package:education_app/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theming/app_colors.dart';
import '../../../../../../core/theming/styles.dart';
import '../../../../../../core/widgets/main_button.dart';
import '../../manger/check_answers_cubit/check_answer_cubit.dart';

Future<void> addingNoteModalBottomSheet(
    BuildContext context,
    CheckAnswerCubit checkAnswerCubit,
    TextEditingController noteController) async {
  final formKey = GlobalKey<FormState>();
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.backGroundColor,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.7,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                20.verticalSpace,
                const Text(
                  "Add a note to your student",
                  style: Styles.bodyLarge16,
                ),
                30.verticalSpace,
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: noteController,
                    maxLines: null,
                    maxLength: 200,
                    expands: false,
                    cursorColor: Theme.of(context).primaryColor,
                    validator: (note) {
                      return note.isNullOrEmpty()
                          ? "Please enter your note"
                          : null;
                    },
                  ),
                ),
                50.verticalSpace,
                MainButton(
                    text: "Save",
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        checkAnswerCubit.hasNote = true;
                        context.pop();
                      }
                    })
              ],
            ),
          ),
        ),
      );
    },
  );
  if (noteController.text.isNullOrEmpty()) {
    checkAnswerCubit.hasNote = false;
  }
}
