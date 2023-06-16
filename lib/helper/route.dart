import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import '../blocs/home_bloc/home_bloc.dart';
import '../blocs/signin_bloc/signin_bloc.dart';
import '../blocs/signup_bloc/signup_bloc.dart';
import '../pages/home/homepage_page.dart';
import '../pages/signin/signin_page.dart';
import '../pages/signup/signup_page.dart';
import '../utils/constants.dart';

Route createSignInPageRoute() {
  return PageTransition(
    type: PageTransitionType.leftToRight,
    duration: const Duration(milliseconds: animationDuration),
    child: BlocProvider<SignInBloc>(
      create: (context) => SignInBloc(
        SignInInitial(),
      ),
      child: const SignInPage(),
    ),
  );
}

Route createSignUpPageRoute() {
  return PageTransition(
    type: PageTransitionType.leftToRight,
    duration: const Duration(milliseconds: animationDuration),
    child: BlocProvider<SignUpBloc>(
      create: (context) => SignUpBloc(
        SignUpInitial(),
      ),
      child: const SignUpPage(),
    ),
  );
}

Route createHomePageRoute(bool isLogin) {
  return PageTransition(
    type: PageTransitionType.leftToRight,
    duration: const Duration(milliseconds: animationDuration),
    child: BlocProvider<HomePageBloc>(
      create: (context) => HomePageBloc(
        HomeInitial(),
      ),
      child: HomePage(
        isLogin: isLogin,
      ),
    ),
  );
}
