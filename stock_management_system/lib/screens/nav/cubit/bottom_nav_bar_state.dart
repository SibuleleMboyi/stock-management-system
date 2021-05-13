part of 'bottom_nav_bar_cubit.dart';

@immutable
class BottomNavBarState {
  final BottomNavItem selectedItem;

  BottomNavBarState({
    this.selectedItem,
  });

  /// Bottom Navigation Item of the Screen that must be displayed on initial launch of the HomeScreen.
  factory BottomNavBarState.initial() {
    return BottomNavBarState(
      selectedItem: BottomNavItem.shippingIn,
    );
  }

  BottomNavBarState copyWith({
    BottomNavItem selectedItem,
  }) {
    return BottomNavBarState(
      selectedItem: selectedItem ?? this.selectedItem,
    );
  }
}
