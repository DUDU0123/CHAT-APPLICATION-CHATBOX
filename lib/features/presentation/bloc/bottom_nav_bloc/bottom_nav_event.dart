part of 'bottom_nav_bloc.dart';

@immutable
sealed class BottomNavEvent {}


class BottomNavIconClickedEvent extends BottomNavEvent {
  final int currentIndex;
  BottomNavIconClickedEvent({
    required this.currentIndex,
  });
}
