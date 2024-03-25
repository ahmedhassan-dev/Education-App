import 'package:education_app/features/onboarding/ui/widgets/user_type_list.dart';
import 'package:flutter/material.dart';

class CustomListViewUserType extends StatelessWidget {
  const CustomListViewUserType({
    super.key,
  });

  static const List<String> userTypeList = ["Teacher", "Student"];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userTypeList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        final userType = userTypeList[i];
        return UserTypeList(
          userType: userType,
        );
      },
    );
  }
}
