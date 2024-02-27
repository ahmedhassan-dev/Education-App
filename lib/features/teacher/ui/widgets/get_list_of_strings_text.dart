import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetListOfStringsText extends StatelessWidget {
  final List<String> stringList;
  const GetListOfStringsText({super.key, required this.stringList});

  @override
  Widget build(BuildContext context) {
    String allItems = stringList.join(', ');
    return allItems.isNotEmpty
        ? Column(
            children: [
              Text(
                allItems,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 7.h,
              )
            ],
          )
        : const SizedBox();
  }
}
