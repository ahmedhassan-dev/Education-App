import 'package:education_app/business_logic/auth_cubit/auth_cubit.dart';
import 'package:education_app/utilities/assets.dart';
import 'package:education_app/utilities/enums.dart';
import 'package:education_app/utilities/routes.dart';
import 'package:education_app/presentation/widgets/main_button.dart';
import 'package:education_app/presentation/widgets/main_dialog.dart';
import 'package:education_app/presentation/widgets/social_media_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    try {
      await BlocProvider.of<AuthCubit>(context).submit();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.landingPageRoute);
    } catch (e) {
      MainDialog(context: context, title: 'Error', content: e.toString())
          .showAlertDialog();
    }
  }

  Future<void> _googleLogIn(BuildContext context) async {
    try {
      await BlocProvider.of<AuthCubit>(context).googleLogIn();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.landingPageRoute);
    } catch (e) {
      MainDialog(context: context, title: 'Error', content: e.toString())
          .showAlertDialog();
    }
  }

  showProgressIndicator() {
    const Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
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
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_passwordFocusNode),
                        textInputAction: TextInputAction.next,
                        onChanged:
                            BlocProvider.of<AuthCubit>(context).updateEmail,
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
                        text:
                            BlocProvider.of<AuthCubit>(context).authFormType ==
                                    AuthFormType.login
                                ? 'Login'
                                : 'Register',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            showProgressIndicator();
                            _submit(context);
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
                            BlocProvider.of<AuthCubit>(context)
                                .toggleFormType();
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
                              showProgressIndicator();
                              _googleLogIn(context);
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
      },
    );
  }
}
