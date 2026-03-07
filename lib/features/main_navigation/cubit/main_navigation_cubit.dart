import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_navigation_state.dart';

class MainNavigationCubit extends Cubit<MainNavigationState> {
  MainNavigationCubit() : super(MainNavigationInitial());

  int currentIndex = 0;

  void changeTab(int index) {
    currentIndex = index;
    emit(MainNavigationTabChanged(tabIndex: index));
  }

  static MainNavigationCubit get(context) => BlocProvider.of(context);
}
