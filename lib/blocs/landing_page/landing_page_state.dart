part of 'landing_page_bloc.dart';

@immutable
abstract class LandingPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class LandingPageInitial extends LandingPageState {}

class ChooseLoginType extends LandingPageState {}

class MemberArea extends LandingPageState {}

class GuestArea extends LandingPageState {}
