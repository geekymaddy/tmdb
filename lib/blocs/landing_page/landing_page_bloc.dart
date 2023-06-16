import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'landing_page_event.dart';
part 'landing_page_state.dart';

class LandingPageBloc extends Bloc<LandingPageEvent, LandingPageState> {
  LandingPageBloc() : super(LandingPageInitial()) {
    on<LandingPageGetStartedButtonTap>((event, emit) {

      emit(ChooseLoginType());
    //  emit(MemberArea());

    });

    on<LandingPageMemberButtonTap>((event, emit) {

      emit(MemberArea());

    });

    on<LandingPageGuestButtonTap>((event, emit) {

      emit(GuestArea());

    });
  }
}
