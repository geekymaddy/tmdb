part of 'signup_bloc.dart';

@immutable
abstract class SignUpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {}

class Loading extends SignUpState {}

class SignUpError extends SignUpState {
  final String errorMessage;

  SignUpError({required this.errorMessage});
}
class SignUpSuccess extends SignUpState {
  final String message;

  SignUpSuccess({required this.message});
}
