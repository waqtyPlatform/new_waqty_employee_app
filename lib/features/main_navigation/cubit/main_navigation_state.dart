abstract class MainNavigationState {}

class MainNavigationInitial extends MainNavigationState {}

class MainNavigationTabChanged extends MainNavigationState {
  final int tabIndex;

  MainNavigationTabChanged({required this.tabIndex});
}
