import 'package:flutter/material.dart';
import 'package:stock_management_system/screens/shipping_out/widgets/form.dart';

/// Stock that is being shipped off shelves

class ShippingOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Sell Stock')),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 30.0, 12.0, 12.0),
            child: FormWidget(),
          ),
        ),
      ),
    );
  }
}
