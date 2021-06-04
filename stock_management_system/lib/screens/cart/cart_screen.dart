import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/blocs/blocs.dart';
import 'package:stock_management_system/repositories/products/product_repository.dart';
import 'package:stock_management_system/repositories/storage/storage_repository.dart';
import 'package:stock_management_system/repositories/user/user_repository.dart';
import 'package:stock_management_system/screens/cart/cubit/cart_cubit.dart';
import 'package:stock_management_system/widgets/widgets.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => BlocProvider(
              create: (_) => CartCubit(
                productRepository: context.read<ProductRepository>(),
                authBloc: context.read<AuthBloc>(),
                userRepository: context.read<UserRepository>(),
                storageRepository: context.read<StorageRepository>(),
              ),
              child: CartScreen(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state.status == CartStatus.success) {
          context.read<CartCubit>().reset();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              content: const Text('transaction successful'),
            ),
          );
        } else if (state.status == CartStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        context.read<CartCubit>().products();
        return RefreshIndicator(
          onRefresh: () async {
            context.read<CartCubit>().products();
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text('Cart'),
                ),
                leading: BackButton(
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  TextButton(
                    onPressed: () => context.read<CartCubit>().submitOrder(),
                    child: Text('buy'),
                  )
                ],
              ),
              body: ListView.builder(
                itemCount: state.productsList.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = state.productsList[index];
                  final quantity = product.quantity;
                  final price = product.price;
                  return ListTile(
                    leading: Text(index.toString() + ". "),
                    title: Row(
                      children: [
                        Text(
                          product.productName + '(' + quantity.toString() + ')',
                        ),
                        SizedBox(width: 40.0),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        if (state.status == CartStatus.submitting)
                          const LinearProgressIndicator(),
                        Row(children: [
                          Text('each item :'),
                          SizedBox(width: 20),
                          Text('R' + price.toString()),
                        ]),
                        Row(children: [
                          Text('total price :'),
                          SizedBox(width: 20),
                          Text('R' + (quantity * price).toString()),
                        ]),
                      ],
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    trailing: TextButton(
                      onPressed: () {
                        context
                            .read<CartCubit>()
                            .removeItem(productBarCode: product.productBarCode);
                      },
                      child: Text('remove'),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
