part of 'signin_bloc.dart';

abstract class SignInEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HandleSignInClick extends SignInEvent {
  final String email;
  final String password;

  HandleSignInClick({required this.email, required this.password});
}
