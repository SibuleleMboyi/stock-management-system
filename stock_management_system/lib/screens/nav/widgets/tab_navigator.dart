import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/blocs/blocs.dart';
import 'package:stock_management_system/config/custom_router.dart';
import 'package:stock_management_system/repositories/products/product_repository.dart';
import 'package:stock_management_system/repositories/repositories.dart';
import 'package:stock_management_system/screens/nav/enums/enums.dart';
import 'package:stock_management_system/screens/profile/bloc/profile_bloc.dart';
import 'package:stock_management_system/screens/screens.dart';
import 'package:stock_management_system/screens/shipping_in/cubit/shipping_in_cubit.dart';
import 'package:stock_management_system/screens/shipping_out/cubit/shippingout_cubit.dart';
import 'package:stock_management_system/screens/transactions/cubit/transactions_cubit.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({
    Key key,
    this.navigatorKey,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();

    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute](context),
          ),
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {
      tabNavigatorRoot: (context) => _getScreen(context, item),
    };
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.shippingIn:
        return BlocProvider<ShippingInCubit>(
          create: (_) => ShippingInCubit(
            productRepository: context.read<ProductRepository>(),
          ),
          child: ShippingInScreen(),
        );

      case BottomNavItem.shippingOut:
        return BlocProvider<ShippingOutCubit>(
          create: (_) => ShippingOutCubit(
            productRepository: context.read<ProductRepository>(),
          ),
          child: ShippingOutScreen(),
        );

      case BottomNavItem.transactions:
        return BlocProvider(
          create: (context) => TransactionsCubit(
            productRepository: context.read<ProductRepository>(),
          ),
          child: TransactionsScreen(),
        );

      case BottomNavItem.profile:
        return BlocProvider(
          create: (context) => ProfileBloc(
            authRepository: context.read<AuthRepository>(),
            userRepository: context.read<UserRepository>(),
            authBloc: context.read<AuthBloc>(),
          )..add(ProfileLoadInitialInfo()),
          child: ProfileScreen(),
        );

      default:
        return Scaffold();
    }
  }
}
