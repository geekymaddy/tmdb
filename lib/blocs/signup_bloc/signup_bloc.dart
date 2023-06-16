import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import '../../repositories/signup_repository.dart';
import '../../utils/strings.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignUpBloc extends Bloc<SignupEvent, SignUpState> {
  SignUpBloc(SignUpInitial signUpInitial) : super(SignUpInitial()) {
    SignUpRepository signUpRepository = SignUpRepository();
    on<HandleSignUpClick>((event, emit) async {
      emit(Loading());
      String response = "";
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        await signUpRepository
            .signUpUser(
                email: event.email, name: event.name, password: event.password)
            .then((value) {
          response = value;
        });
        print("response :: $response");
        if (response == "success") {
          emit(SignUpSuccess(message: response));
        } else {
          emit(SignUpError(errorMessage: response));
        }
      } else {
        emit(SignUpError(errorMessage: Strings.noInternet));
      }
    });
  }
}
