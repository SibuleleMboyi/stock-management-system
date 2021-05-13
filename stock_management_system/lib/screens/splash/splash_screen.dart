import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:stock_management_system/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/Splash';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            Navigator.of(context).pushNamed(LoginScreen.routeName);
          } else if (state.status == AuthStatus.authenticated) {
            Navigator.of(context).pushNamed(NavigatorScreen.routeName);
          }
        },
        child: Scaffold(
          body: Center(
            child: const CupertinoActivityIndicator(radius: 10),
          ),
        ),
      ),
    );
  }
}
