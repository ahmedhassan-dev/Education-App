import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/authentication/logic/auth_cubit.dart';
import 'package:education_app/core/constants/assets.dart';
import 'package:education_app/core/constants/enums.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/core/widgets/main_button.dart';
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
  final _userFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _mobileController = TextEditingController();
  final _userNameController = TextEditingController();
  final _mobileFocusNode = FocusNode();
  final _userNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context).setUserType(userType: widget.userType);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  Widget buildBlocWidget() {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SubmitionVerified) {
          Navigator.of(context)
              .pushReplacementNamed(AppRoutes.landingPageRoute);
        } else if (state is GetUserData) {
          showUserDataModel(context);
        } else if (state is ErrorOccurred) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.scale,
            title: 'Error Found!',
            desc: state.errorMsg,
            dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
          ).show();
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

  showUserDataModel(BuildContext blocContext,
      {bool? createUserWithEmailAndPassword}) {
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
              key: _userFormKey,
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
                      controller: _userNameController,
                      focusNode: _userNameFocusNode,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(_mobileFocusNode),
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
                      controller: _mobileController,
                      focusNode: _mobileFocusNode,
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
                        if (_userFormKey.currentState!.validate()) {
                          if (createUserWithEmailAndPassword == true) {
                            BlocProvider.of<AuthCubit>(blocContext).signUp(
                                _userNameController.text.trim(),
                                _mobileController.text.trim());
                          } else {
                            // Signin with google
                            BlocProvider.of<AuthCubit>(blocContext)
                                .storeUserData(_userNameController.text.trim(),
                                    _mobileController.text.trim());
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
                              createUserWithEmailAndPassword: true);
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
