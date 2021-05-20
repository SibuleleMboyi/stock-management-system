import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => CartScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Cart'),
        ),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child:
            /* ListView.builder(
                itemCount: Lists.cartList.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = Lists.cartList[index];

                  return ListTile(
                    leading: Text(index.toString() + ". "),
                    title: Text(product.productName),
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    trailing: TextButton(
                      onPressed: () {
                        Lists.cartList.remove(index);
                      },
                      child: Text('remove'),
                    ),
                  );
                },
              ) */
            Container(
          height: 400,
          width: double.infinity,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
