import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/home/data/repo/home_repo.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(InitialState());

  // Example Logic method
  // getHomeData() {
  //   emit(OnHomeLoadingState());
  //   _homeRepo.getHomeData().then((value) {
  //     value.fold(
  //         (l) => emit(OnHomeErrorState()),
  //         (r) => emit(OnHomeSuccessState()));
  //   }).catchError((error) {
  //     emit(OnHomeCatchErrorState());
  //   });
  // }

  static HomeCubit get(context) => BlocProvider.of(context);
}
