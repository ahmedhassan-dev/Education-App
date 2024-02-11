import 'package:education_app/presentation/widgets/user_type_list.dart';
import 'package:flutter/material.dart';

class SelectUserPage extends StatelessWidget {
  const SelectUserPage({super.key});

  buildUserTypeList() {
    const List<String> userTypeList = ["Teacher", "Student"];
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [buildUserTypeList(), const SizedBox(height: 24.0)],
    );
  }
}
