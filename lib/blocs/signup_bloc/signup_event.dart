part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class HandleSignUpClick extends SignupEvent {
  final String name;
  final String email;
  final String password;

  HandleSignUpClick(
      {required this.name, required this.email, required this.password});
}
