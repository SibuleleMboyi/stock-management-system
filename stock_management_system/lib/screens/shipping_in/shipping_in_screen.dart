import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/repositories/repositories.dart';
import 'package:stock_management_system/screens/screens.dart';
import 'package:stock_management_system/screens/shipping_in/cubit/shipping_in_cubit.dart';
import 'package:stock_management_system/screens/shipping_in/widgets/form.dart';

/// New stock that is coming to be stocked into the shelves

class ShippingInScreen extends StatelessWidget {
  static const String routeName = '/shipping_in';
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ShippingInCubit>(
        create: (_) => ShippingInCubit(
            productRepository: context.read<ProductRepository>()),
        child: ShippingInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Add New Stock')),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 30.0, 12.0, 12.0),
              child: FormWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
