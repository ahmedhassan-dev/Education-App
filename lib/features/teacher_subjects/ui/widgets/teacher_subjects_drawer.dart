import 'package:education_app/core/helpers/context_extension.dart';
import 'package:education_app/features/onboarding/logic/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/functions/service_locator.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/app_colors.dart';

class TeacherSubjectDrawer extends StatelessWidget {
  const TeacherSubjectDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backGroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome, ${getIt<SharedPreferences>().getString("userName")}!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  getIt<SharedPreferences>().getString("email") ?? "UnKnown",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // // Home
          // ListTile(
          //   leading: const Icon(Icons.home),
          //   title: const Text('Home'),
          //   onTap: () {
          //     Navigator.pushNamed(context, '/home');
          //   },
          // ),

          // // Profile
          // ListTile(
          //   leading: const Icon(Icons.person),
          //   title: const Text('Profile'),
          //   onTap: () {
          //     Navigator.pushNamed(context, '/profile');
          //   },
          // ),

          // // Courses
          // ListTile(
          //   leading: const Icon(Icons.book),
          //   title: const Text('Courses'),
          //   onTap: () {
          //     Navigator.pushNamed(context, '/courses');
          //   },
          // ),

          // // Notifications
          // ListTile(
          //   leading: const Icon(Icons.notifications),
          //   title: const Text('Notifications'),
          //   onTap: () {
          //     Navigator.pushNamed(context, '/notifications');
          //   },
          // ),

          // // Settings
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text('Settings'),
          //   onTap: () {
          //     Navigator.pushNamed(context, '/settings');
          //   },
          // ),

          // const Divider(),

          // Privacy Policy
          ListTile(
            leading: const Icon(Icons.question_answer_rounded),
            title: const Text('Answers'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.studentsFeedbackRoute);
            },
          ),

          // Privacy Policy
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.privacyPolicy);
            },
          ),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              context.pop();
              context.read<OnboardingCubit>().logOut();
            },
          ),
          // Divider
          const Divider(),

          // Delete Account
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text(
                        'Are you sure you want to permanently delete your account? This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Perform account deletion logic
                          dialogContext.pop();
                          context
                              .read<OnboardingCubit>()
                              .deleteAccount(context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Account deleted successfully.'),
                          ));
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
