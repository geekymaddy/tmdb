part of 'landing_page_bloc.dart';

@immutable
abstract class LandingPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LandingPageGetStartedButtonTap extends LandingPageEvent {}

class LandingPageGuestButtonTap extends LandingPageEvent {}

class LandingPageMemberButtonTap extends LandingPageEvent {}
