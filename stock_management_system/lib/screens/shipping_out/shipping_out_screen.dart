import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/repositories/products/product_repository.dart';
import 'package:stock_management_system/screens/shipping_out/cubit/shippingout_cubit.dart';
import 'package:stock_management_system/screens/shipping_out/widgets/form.dart';

/// Stock that is being shipped off shelves
class ShippingOutScreen extends StatelessWidget {
  static const String routeName = '/shipping_out';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ShippingOutCubit>(
        create: (_) => ShippingOutCubit(
            productRepository: context.read<ProductRepository>()),
        child: ShippingOutScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Sell Stock')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 30.0, 12.0, 12.0),
                child: FormWidget(),
              ),
            ),
            /* ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                shadowColor: Colors.grey,
              ),
              child: Text('cart'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ), */
          ],
        ),
      ),
    );
  }
}
