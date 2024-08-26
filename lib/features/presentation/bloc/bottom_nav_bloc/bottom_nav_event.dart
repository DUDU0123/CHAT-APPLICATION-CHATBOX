part of 'bottom_nav_bloc.dart';

@immutable
sealed class BottomNavEvent extends Equatable{}


class BottomNavIconClickedEvent extends BottomNavEvent {
  final int currentIndex;
  BottomNavIconClickedEvent({
    required this.currentIndex,
  });
  @override
  List<Object?> get props => [currentIndex];
}
class MainContentShowEvent extends BottomNavEvent {
  final bool showMainContent;
  MainContentShowEvent({
    required this.showMainContent,
  });
  @override
  List<Object?> get props => [showMainContent];
}
