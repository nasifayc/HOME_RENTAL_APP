import 'package:flutter_bloc/flutter_bloc.dart';

enum BottomNavState { home, post, chat }

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(BottomNavState.home);

  void selectItem(BottomNavState item) {
    emit(item);
  }
}
