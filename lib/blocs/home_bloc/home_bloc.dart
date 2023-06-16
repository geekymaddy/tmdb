import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc(HomeInitial homeInitial) : super(HomeInitial()) {
    on<HomePageEvent>((event, emit) {});
  }
}
