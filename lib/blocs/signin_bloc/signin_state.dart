part of 'signin_bloc.dart';

@immutable
abstract class SignInState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {}

class Loading extends SignInState {}

class SignInSuccess extends SignInState {
  final String message;

  SignInSuccess({required this.message});
}

class SignInError extends SignInState {
  final String errorMessage;

  SignInError({required this.errorMessage});
}
