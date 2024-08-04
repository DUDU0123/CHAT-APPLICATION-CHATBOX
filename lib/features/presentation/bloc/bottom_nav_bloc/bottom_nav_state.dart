part of 'bottom_nav_bloc.dart';

@immutable
class BottomNavState {
  final int currentIndex;
  const BottomNavState({
     this.currentIndex = 0,
  });
}

class BottomNavErrorState extends BottomNavState{}