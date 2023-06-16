import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:tmdb/repositories/signin_repository.dart';

import '../../utils/strings.dart';

part 'signin_event.dart';

part 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc(SignInInitial signupInitial) : super(SignInInitial()) {
    SignInRepository signInRepository = SignInRepository();
    on<HandleSignInClick>((event, emit) async {
      emit(Loading());
      String response = "";
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        await signInRepository
            .signInUser(email: event.email, password: event.password)
            .then((value) {
          response = value;
        });
        print("response :: $response");
        if (response == Strings.signIn) {
          emit(SignInSuccess(message: response));
        } else {
          emit(SignInError(errorMessage: response));
        }
      } else {
        emit(SignInError(errorMessage: Strings.noInternet));
      }
    });
  }
}
