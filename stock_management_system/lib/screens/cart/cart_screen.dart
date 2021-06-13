import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/blocs/blocs.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/products/product_repository.dart';
import 'package:stock_management_system/repositories/storage/storage_repository.dart';
import 'package:stock_management_system/repositories/user/user_repository.dart';
import 'package:stock_management_system/screens/cart/cubit/cart_cubit.dart';
import 'package:stock_management_system/widgets/widgets.dart';

class CartScreen extends StatefulWidget {
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
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final key = GlobalKey<AnimatedListState>();

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
                    onPressed: () {
                      state.productsList.length != 0
                          ? context.read<CartCubit>().submitOrder()
                          : print('cart is empty');
                    },
                    child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.black12,
                        ),
                        child: Text('buy')),
                  )
                ],
              ),
              body: Column(
                children: [
                  state.status == CartStatus.submitting
                      ? const LinearProgressIndicator()
                      : SizedBox.shrink(),
                  Expanded(
                    child: state.productsList.length != 0
                        ? AnimatedList(
                            key: key,
                            initialItemCount: state.productsList.length,
                            itemBuilder: (context, index, animation) {
                              return buildItem(
                                state.productsList[index],
                                index,
                                animation,
                                state.productsList,
                                context,
                              );
                            })
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void removedItem(int index, List items, BuildContext context) {
    final item = items.removeAt(index);
    key.currentState.removeItem(
      index,
      (context, animation) => buildItem(item, index, animation, items, context),
    );
  }

  Widget buildItem(Product item, int index, Animation<double> animation, items,
      BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.black12,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          leading: Text((index + 1).toString() + '.'),
          title: Row(
            children: [
              Text(
                item.productName + '(' + item.quantity.toString() + ')',
              ),
              SizedBox(width: 40.0),
            ],
          ),
          subtitle: Column(
            children: [
              Row(
                children: [],
              ),
              Row(
                children: [
                  Text('each item :'),
                  SizedBox(width: 20),
                  Text('R' + item.price.toString()),
                ],
              ),
              Row(
                children: [
                  Text('total price :'),
                  SizedBox(width: 20),
                  Text('R' + (item.quantity * item.price).toString()),
                ],
              ),
            ],
          ),
          trailing: TextButton(
            onPressed: () {
              context
                  .read<CartCubit>()
                  .removeItem(productBarCode: items[index].productBarCode);
              removedItem(index, items, context);
            },
            child: Text('remove'),
          ),
        ),
      ),
    );
  }
}
