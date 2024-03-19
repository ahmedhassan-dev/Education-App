import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

AwesomeDialog keepGoingAwesomeDialog(context) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    animType: AnimType.scale,
    title: 'Nice Answer😊!',
    desc: 'Keep Going❤️',
    dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
  );
}

AwesomeDialog reviewAnswerAwesomeDialog(context) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.infoReverse,
    animType: AnimType.scale,
    title: 'Keep Going😉',
    desc: 'We will review your answer soon❤️!',
    dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
    // btnCancelOnPress: () {},
    // btnOkOnPress: () {},
  );
}

AwesomeDialog errorAwesomeDialog(context, Object e) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    animType: AnimType.scale,
    title: 'Error Submiting Solution',
    desc: e.toString(),
    dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
  );
}
