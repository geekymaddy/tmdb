import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/signup_bloc/signup_bloc.dart';
import '../../helper/route.dart';
import '../../helper/size_helpers.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';
import '../../utils/style.dart';
import '../../utils/widgets/snackbar.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;
  late SignUpBloc _signUpBloc;

  @override
  void initState() {
    super.initState();
    _signUpBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _getBodyLayout(context),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    _signUpBloc.close();
  }

  Widget _getBodyLayout(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpError) {
          CustomSnackBar.negativeSnackBar(
            context: context,
            message: state.errorMessage ?? '',
          );
        } else if (state is SignUpSuccess) {
          CustomSnackBar.positiveSnackBar(
            context: context,
            message: state.message ?? '',
          );
          Navigator.pushReplacement(context, createSignInPageRoute());
        }
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: displayHeight(context) * .05,
                      ),
                      const Text(
                        Strings.signUp,
                        style: signInTextStyle,
                      ),
                      SizedBox(
                        height: displayHeight(context) * .02,
                      ),
                      const Text(
                        Strings.signInDescription,
                        style: signInDesStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: displayHeight(context) * .04,
                      ),
                      _nameField(),
                      SizedBox(
                        height: displayHeight(context) * .03,
                      ),
                      _emailField(),
                      SizedBox(
                        height: displayHeight(context) * .03,
                      ),
                      _passwordField(),
                      SizedBox(
                        height: displayHeight(context) * .03,
                      ),
                      _confirmPasswordField(),
                      SizedBox(
                        height: displayHeight(context) * .01,
                      ),
                      _signupText(),
                      SizedBox(
                        height: displayHeight(context) * .03,
                      ),
                      _signInButton(context),
                      SizedBox(
                        height: displayHeight(context) * .01,
                      ),
                      _signInContainer(context),
                    ],
                  ),
                ),
              ),
              _loadingIndicator(),
            ],
          ),
        );
      }),
    );
  }

  TextFormField _passwordField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return Strings.fieldValidation;
        } else if (value.length < 6) {
          return Strings.passwordLengthValidation;
        } else {
          return null;
        }
      },
      obscureText: passwordVisible,
      controller: _passwordController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon:
                Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(
                () {
                  passwordVisible = !passwordVisible;
                },
              );
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: textFieldBorderColour),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: textFieldBorderColour),
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          hintStyle: textFieldStyle,
          hintText: Strings.password,
          fillColor: Colors.white),
    );
  }

  TextFormField _emailField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return Strings.fieldValidation;
        } else {
          if (!value.contains('@') || !value.contains('.')) {
            return Strings.emailValidation;
          } else {
            return null;
          }
        }
      },
      controller: _emailController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: textFieldBorderColour),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: textFieldBorderColour),
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          hintStyle: textFieldStyle,
          hintText: Strings.userName,
          fillColor: Colors.white),
    );
  }

  Widget _loadingIndicator() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        if (state is Loading) {
          return AbsorbPointer(
            absorbing: true,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _signInButton(BuildContext context) {
    return SizedBox(
      width: displayWidth(context),
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            FocusScope.of(context).unfocus();
            _signUpBloc.add(
              HandleSignUpClick(
                  name: _nameController.text,
                  email: _emailController.text,
                  password: _passwordController.text),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.red, // Background color
        ),
        child: const Text(
          Strings.signUp,
          style: buttonTextStyle,
        ),
      ),
    );
  }

  Widget _signInContainer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          Strings.alreadyHaveAccount,
          style: textFieldStyle,
        ),
        InkWell(
          onTap: () {
            Navigator.pushReplacement(context, createSignInPageRoute());
          },
          child: const Text(
            Strings.signIn,
            style: signUpTextFieldStyle,
          ),
        ),
      ],
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return Strings.fieldValidation;
        } else {
          if (_passwordController.text != _confirmPasswordController.text) {
            return Strings.passwordMismatch;
          } else {
            return null;
          }
        }
      },
      obscureText: confirmPasswordVisible,
      controller: _confirmPasswordController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(confirmPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off),
            onPressed: () {
              setState(
                () {
                  confirmPasswordVisible = !confirmPasswordVisible;
                },
              );
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: textFieldBorderColour),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: textFieldBorderColour),
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          hintStyle: textFieldStyle,
          hintText: Strings.confirmPassword,
          fillColor: Colors.white),
    );
  }

  Widget _signupText() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        Strings.privacyPolicy,
        style: textFieldStyleSmall,
      ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return Strings.fieldValidation;
        }
        return null;
      },
      controller: _nameController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: textFieldBorderColour),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: textFieldBorderColour),
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          hintStyle: textFieldStyle,
          hintText: Strings.name,
          fillColor: Colors.white),
    );
  }
}
