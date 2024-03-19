import 'package:education_app/core/theming/styles.dart';
import 'package:education_app/features/problems/logic/problems_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NeedHelpTextButton extends StatefulWidget {
  final BuildContext context;
  const NeedHelpTextButton({super.key, required this.context});

  @override
  State<NeedHelpTextButton> createState() => _NeedHelpTextButtonState();
}

class _NeedHelpTextButtonState extends State<NeedHelpTextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
      ),
      onPressed: () {
        BlocProvider.of<ProblemsCubit>(context).showNeedHelpList();
      },
      child: const Text(
        'Need Help?',
        style: Styles.needHelpTextStyle,
      ),
    );
  }
}
