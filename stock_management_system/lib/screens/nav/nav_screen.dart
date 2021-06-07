import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:stock_management_system/screens/nav/enums/enums.dart';
import 'package:stock_management_system/screens/nav/widgets/bottom_nav_bar.dart';
import 'package:stock_management_system/screens/nav/widgets/tab_navigator.dart';

class NavigatorScreen extends StatelessWidget {
  static const String routeName = '/nav';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<BottomNavBarCubit>(
        create: (_) => BottomNavBarCubit(),
        child: NavigatorScreen(),
      ),
    );
  }

  /// used to maintain state of each navigator tap or navigator item.
  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.shippingIn: GlobalKey<NavigatorState>(),
    BottomNavItem.shippingOut: GlobalKey<NavigatorState>(),
    BottomNavItem.brands: GlobalKey<NavigatorState>(),
    BottomNavItem.transactions: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, List> items = const {
    BottomNavItem.shippingIn: [Icons.home, 'Stock In'],
    BottomNavItem.shippingOut: [Icons.add, 'Stock Out'],
    BottomNavItem.brands: [Icons.food_bank, 'Brands'],
    BottomNavItem.transactions: [Icons.home, 'Transactions'],
    BottomNavItem.profile: [Icons.home, 'profile'],
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white70,
            body: Stack(
              children: items
                  .map(
                    (item, list) => MapEntry(
                      item,
                      _buildOffStageNavigator(
                        item,
                        item == state.selectedItem,
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
            bottomNavigationBar: BottomNavBar(
              items: items,
              selectedItem: state.selectedItem,
              onTap: (index) {
                final selectedItem = BottomNavItem.values[index];
                _selectedBottomNavItem(
                  context,
                  selectedItem,
                  selectedItem == state.selectedItem,
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _selectedBottomNavItem(
      BuildContext context, BottomNavItem selectedItem, bool isSameItem) {
    if (isSameItem) {
      navigatorKeys[selectedItem]
          .currentState
          .popUntil((route) => route.isFirst);
    }
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }

  Widget _buildOffStageNavigator(BottomNavItem currentItem, bool isSelected) {
    return Offstage(
        offstage: !isSelected,
        child: TabNavigator(
          navigatorKey: navigatorKeys[currentItem],
          item: currentItem,
        ));
  }
}
