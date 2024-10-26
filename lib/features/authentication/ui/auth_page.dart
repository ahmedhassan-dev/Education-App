import 'package:education_app/core/widgets/awesome_dialog.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/authentication/logic/auth_cubit.dart';
import 'package:education_app/core/constants/assets.dart';
import 'package:education_app/core/constants/enums.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/core/widgets/main_button.dart';
import 'package:education_app/features/authentication/ui/user_data_model.dart';
import 'package:education_app/features/authentication/ui/widgets/social_media_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  final String userType;
  const AuthPage({required this.userType, super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final mobileController = TextEditingController();
  final userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context).setUserType(userType: widget.userType);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    mobileController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  Widget buildBlocWidget() {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SubmitionVerified) {
          Navigator.of(context)
              .pushReplacementNamed(AppRoutes.landingPageRoute);
        } else if (state is GetUserData) {
          showUserDataModel(context,
              userNameController: userNameController,
              mobileController: mobileController);
        } else if (state is ErrorOccurred) {
          errorAwesomeDialog(context, state.errorMsg, title: 'Error Found!')
              .show();
        }
      },
      builder: (context, state) {
        if (state is Loading) {
          return const ShowLoadingIndicator();
        }
        return authWidget();
      },
    );
  }

  Widget authWidget() {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 60.0,
            horizontal: 32.0,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    BlocProvider.of<AuthCubit>(context).authFormType ==
                            AuthFormType.login
                        ? 'Login'
                        : 'Register',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 80.0),
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_passwordFocusNode),
                    textInputAction: TextInputAction.next,
                    onChanged: BlocProvider.of<AuthCubit>(context).updateEmail,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter your email!' : null,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email!',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter your password!' : null,
                    onChanged:
                        BlocProvider.of<AuthCubit>(context).updatePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your pasword!',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (BlocProvider.of<AuthCubit>(context).authFormType ==
                      AuthFormType.login)
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        child: const Text('Forgot your password?'),
                        onTap: () {},
                      ),
                    ),
                  const SizedBox(height: 24.0),
                  MainButton(
                    text: BlocProvider.of<AuthCubit>(context).authFormType ==
                            AuthFormType.login
                        ? 'Login'
                        : 'Register',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (BlocProvider.of<AuthCubit>(context).authFormType ==
                            AuthFormType.login) {
                          BlocProvider.of<AuthCubit>(context).signIn();
                        } else {
                          showUserDataModel(context,
                              createUserWithEmailAndPassword: true,
                              userNameController: userNameController,
                              mobileController: mobileController);
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Text(
                        BlocProvider.of<AuthCubit>(context).authFormType ==
                                AuthFormType.login
                            ? 'Don\'t have an account? Register'
                            : 'Have an account? Login',
                      ),
                      onTap: () {
                        _formKey.currentState!.reset();
                        BlocProvider.of<AuthCubit>(context).toggleFormType();
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.09),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        BlocProvider.of<AuthCubit>(context).authFormType ==
                                AuthFormType.login
                            ? 'Or Login with'
                            : 'Or Register with',
                        style: Theme.of(context).textTheme.titleMedium,
                      )),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialMediaButton(
                        iconName: AppAssets.googleIcon,
                        onPress: () {
                          BlocProvider.of<AuthCubit>(context).googleLogIn();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget();
  }
}
