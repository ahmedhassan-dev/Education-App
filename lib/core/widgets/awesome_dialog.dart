import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

AwesomeDialog keepGoingAwesomeDialog(context,
    {String title = 'Nice Answer😊!'}) {
  final double screenWidth = MediaQuery.of(context).size.width;
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    animType: AnimType.scale,
    title: title,
    desc: 'Keep Going❤️',
    dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
    width: screenWidth > 1000 ? screenWidth * 0.2 : null,
  );
}

AwesomeDialog reviewAnswerAwesomeDialog(context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.infoReverse,
    animType: AnimType.scale,
    title: 'Keep Going😉',
    desc: 'We will review your answer soon❤️!',
    dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
    width: screenWidth > 1000 ? screenWidth * 0.2 : null,
    // btnCancelOnPress: () {},
    // btnOkOnPress: () {},
  );
}

AwesomeDialog errorAwesomeDialog(context, Object e, {String title = 'Error'}) {
  final double screenWidth = MediaQuery.of(context).size.width;
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    animType: AnimType.scale,
    title: title,
    desc: e.toString(),
    dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
    width: screenWidth > 1000 ? screenWidth * 0.2 : null,
  );
}
