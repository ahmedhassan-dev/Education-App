import 'package:flutter/material.dart';

extension Kcontext on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  push(Widget widget) =>
      Navigator.of(this).push(MaterialPageRoute(builder: (context) {
        return widget;
      }));
  pop() => Navigator.of(this).pop();

  pushReplacement(Widget widget) =>
      Navigator.of(this).pushReplacement(MaterialPageRoute(builder: (context) {
        return widget;
      }));
  pushAndRemoveUntil(Widget widget) => Navigator.of(this).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return widget;
      }), (value) {
        return false;
      });
}
