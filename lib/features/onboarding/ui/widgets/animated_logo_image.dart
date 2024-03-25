import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedLogoImage extends StatelessWidget {
  final double height;
  const AnimatedLogoImage({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'HeroTag',
      transitionOnUserGestures: true,
      child: Container(
          height: height.h,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(220)),
          child: Image.asset("assets/logo.jpg")),
    );
  }
}
