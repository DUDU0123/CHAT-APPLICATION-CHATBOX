part of 'bottom_nav_bloc.dart';

@immutable
class BottomNavState extends Equatable{
  final int currentIndex;
  final bool showWelcomWidget;
  const BottomNavState({
    this.currentIndex = 0,
    this.showWelcomWidget = false,
  });
  BottomNavState copyWith({
    bool? showWelcomWidget,
    int? currentIndex
  }){
    return BottomNavState(
      currentIndex: currentIndex??this.currentIndex,
      showWelcomWidget: showWelcomWidget ?? this.showWelcomWidget,
    );
  }
  @override
  List<Object?> get props => [currentIndex, showWelcomWidget,];
}

class BottomNavErrorState extends BottomNavState{}