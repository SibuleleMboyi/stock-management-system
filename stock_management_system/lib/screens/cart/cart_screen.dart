import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/blocs/blocs.dart';
import 'package:stock_management_system/repositories/products/product_repository.dart';
import 'package:stock_management_system/repositories/storage/storage_repository.dart';
import 'package:stock_management_system/repositories/user/user_repository.dart';
import 'package:stock_management_system/screens/cart/cubit/cart_cubit.dart';

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
        // TODO ::
        //context.read<CartCubit>().reset();
      },
      builder: (context, state) {
        context.read<CartCubit>().products();
        return RefreshIndicator(
          onRefresh: () async {
            context.read<CartCubit>().products();
          },
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
                  onPressed: () => context
                      .read<CartCubit>()
                      .submitOrder(cashierId: 'iZu2CzHeeOdmENw66roGPlsAPcm1'),
                  child: Text('buy'),
                )
              ],
            ),
            body: state.productsList.length == null
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.blueAccent,
                  )
                :
                //: Center(child: Text(state.productsList.length.toString()));
                ListView.builder(
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
                              product.productName +
                                  '(' +
                                  quantity.toString() +
                                  ')',
                            ),
                            SizedBox(width: 40.0),
                          ],
                        ),
                        subtitle: Column(
                          children: [
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
                            context.read<CartCubit>().removeItem(
                                productBarCode: product.productBarCode);
                          },
                          child: Text('remove'),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
