import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/signin_bloc/signin_bloc.dart';
import '../../helper/route.dart';
import '../../helper/size_helpers.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';
import '../../utils/style.dart';
import '../../utils/widgets/snackbar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late SignInBloc signupBloc;

  @override
  void initState() {
    super.initState();
    signupBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    signupBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _getBody(context),
      ),
    );
  }

  Widget _getBody(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInError) {
          CustomSnackBar.negativeSnackBar(
            context: context,
            message: state.errorMessage ?? '',
          );
        } else if (state is SignInSuccess) {
          CustomSnackBar.positiveSnackBar(
            context: context,
            message: state.message ?? '',
          );
          Navigator.pushReplacement(context, createHomePageRoute(true));
        }
      },
      child: BlocBuilder<SignInBloc, SignInState>(builder: (context, state) {
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
                        Strings.signIn,
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
                      _usernameField(),
                      SizedBox(
                        height: displayHeight(context) * .03,
                      ),
                      _passwordField(),
                      SizedBox(
                        height: displayHeight(context) * .02,
                      ),
                      _forgetPasswordField(context),
                      SizedBox(
                        height: displayHeight(context) * .03,
                      ),
                      _signInButton(context),
                      SizedBox(
                        height: displayHeight(context) * .02,
                      ),
                      _signUpContainer(context),
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
        }
        return null;
      },
      controller: _passwordController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
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

  TextFormField _usernameField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return Strings.fieldValidation;
        }
        return null;
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
    return BlocBuilder<SignInBloc, SignInState>(
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
            signupBloc.add(HandleSignInClick(
                email: _emailController.text,
                password: _passwordController.text));
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.red, // Background color
        ),
        child: const Text(
          Strings.signIn,
          style: buttonTextStyle,
        ),
      ),
    );
  }

  _forgetPasswordField(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: const Align(
        alignment: Alignment.centerRight,
        child: Text(
          Strings.forgotPassword,
          style: textFieldStyle,
        ),
      ),
    );
  }

  _signUpContainer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          Strings.doNotHaveAccount,
          style: textFieldStyle,
        ),
        InkWell(
          onTap: () {
            Navigator.pushReplacement(context, createSignUpPageRoute());
          },
          child: const Text(
            Strings.signUp,
            style: signUpTextFieldStyle,
          ),
        ),
      ],
    );
  }


}
