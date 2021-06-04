import 'package:flutter/material.dart';
import 'package:stock_management_system/screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(
            backgroundColor: Colors.red,
          ),
        );

      case SplashScreen.routeName:
        return SplashScreen.route();

      case LoginScreen.routeName:
        return LoginScreen.route();

      case SignupScreen.routeName:
        return SignupScreen.route();

      case NavigatorScreen.routeName:
        return NavigatorScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    print('Nested Route: ${settings.name}');

    switch (settings.name) {
      case ShippingOutScreen.routeName:
        return ShippingOutScreen.route();
      case CartScreen.routeName:
        return CartScreen.route();

      case ShippingInScreen.routeName:
        return ShippingOutScreen.route();
      case EditProductScreen.routeName:
        return EditProductScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Error')),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
