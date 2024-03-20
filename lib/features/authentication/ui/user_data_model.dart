import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/widgets/main_button.dart';
import 'package:education_app/features/authentication/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

showUserDataModel(BuildContext blocContext,
    {bool? createUserWithEmailAndPassword,
    required final userNameController,
    required final mobileController}) {
  final userFormKey = GlobalKey<FormState>();
  final mobileFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  return showModalBottomSheet(
    context: blocContext,
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
            key: userFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please enter your name and your mobile number',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 60.0),
                  TextFormField(
                    controller: userNameController,
                    focusNode: userNameFocusNode,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(mobileFocusNode),
                    textInputAction: TextInputAction.next,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter your name!' : null,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your name!',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: mobileController,
                    focusNode: mobileFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number!';
                      } else if (value.length < 11) {
                        return 'Too short for a phone number!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Mobile',
                      hintText: 'Enter your mobile number!',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  MainButton(
                    text: 'Register',
                    onTap: () {
                      if (userFormKey.currentState!.validate()) {
                        if (createUserWithEmailAndPassword == true) {
                          BlocProvider.of<AuthCubit>(blocContext).signUp(
                              userNameController.text.trim(),
                              mobileController.text.trim());
                        } else {
                          // Signin with google
                          BlocProvider.of<AuthCubit>(blocContext).storeUserData(
                              userNameController.text.trim(),
                              mobileController.text.trim());
                        }
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
