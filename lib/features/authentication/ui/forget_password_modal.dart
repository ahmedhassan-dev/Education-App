import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/widgets/main_button.dart';
import 'package:flutter/material.dart';

showForgetPasswordModal(
  BuildContext context, {
  required final emailController,
  required final VoidCallback onTap,
}) {
  final emailFormKey = GlobalKey<FormState>();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.secondaryColor,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 60.0,
            horizontal: 32.0,
          ),
          child: Form(
            key: emailFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please enter your email',
                    //  and your mobile number
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 60.0),
                  TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter your email!' : null,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email!',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  MainButton(
                      text: 'Submit',
                      onTap: () {
                        if (!emailFormKey.currentState!.validate()) return;
                        onTap();
                      }),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
