import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(const BottomNavState(currentIndex: 0)) {
    on<BottomNavIconClickedEvent>(bottomNavIconClickedEvent);
    on<MainContentShowEvent>(mainContentShowEvent);
  }

  FutureOr<void> bottomNavIconClickedEvent(
      BottomNavIconClickedEvent event, Emitter<BottomNavState> emit) {
    try {
      emit(BottomNavState(currentIndex: event.currentIndex));
    } catch (e) {
      debugPrint(e.toString());
      emit(BottomNavErrorState());
    }
  }

  FutureOr<void> mainContentShowEvent(
      MainContentShowEvent event, Emitter<BottomNavState> emit) {
       emit(state.copyWith(showWelcomWidget: event.showMainContent));
      }
}
