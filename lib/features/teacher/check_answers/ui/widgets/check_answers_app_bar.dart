import 'package:education_app/core/helpers/spacing.dart';
import 'package:education_app/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckAnswersAppBar extends StatelessWidget {
  final BuildContext context;
  const CheckAnswersAppBar({
    super.key,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: const Text(
        "Ahmed",
        style: Styles.bodyLarge16,
      ),
      actions: [
        Text(
          "Solved: 10",
          style: Styles.bodyLarge16.copyWith(fontWeight: FontWeight.w600),
        ),
        horizontalSpace(5),
      ],
    );
  }
}
