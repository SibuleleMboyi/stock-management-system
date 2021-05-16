import 'package:flutter/material.dart';
import 'package:stock_management_system/screens/shipping_in/widgets/form.dart';

/// New stock that is coming to be stocked into the shelves

class ShippingInScreen extends StatelessWidget {
  static const String routeName = '/shipping_in';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
