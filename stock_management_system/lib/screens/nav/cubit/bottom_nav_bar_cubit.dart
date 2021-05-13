import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stock_management_system/screens/nav/enums/enums.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(BottomNavBarState.initial());

  void updateSelectedItem(BottomNavItem item) {
    if (item != state.selectedItem) {
      emit(state.copyWith(selectedItem: item));
    }
  }
}
