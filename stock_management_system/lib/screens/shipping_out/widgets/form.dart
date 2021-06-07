import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/helpers/helpers.dart';
import 'package:stock_management_system/screens/screens.dart';
import 'package:stock_management_system/screens/shipping_out/cubit/shippingout_cubit.dart';

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  String errorMessage = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShippingOutCubit, ShippingOutState>(
      listener: (context, state) {
        if (state.status == ShippingOutStatus.success) {
          _formkey.currentState.reset();
          controller.clear();
          context.read<ShippingOutCubit>().reset();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              content: const Text('Item added to cart'),
            ),
          );
        } else if (state.status == ShippingOutStatus.error) {
          errorMessage = state.failure.message;
        }
        if (state.status == ShippingOutStatus.initial) {
          errorMessage = '';
        }
      },
      builder: (context, state) {
        context.read<ShippingOutCubit>().productsFromCart();
        return Column(
          children: [
            (state.status == ShippingOutStatus.submitting)
                ? const LinearProgressIndicator()
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Product Barcode',
                            errorText: errorMessage,
                          ),
                          controller: controller,
                          onChanged: (value) => context
                              .read<ShippingOutCubit>()
                              .productBarcodeChanged(value),
                          validator: (value) => value.isEmpty
                              ? "enter or scan the product's barcode"
                              : null,
                        ),
                        Positioned(
                          top: 8.0,
                          right: 18.0,
                          child: TextButton(
                            onPressed: () => codeScanner(context),
                            child: Column(children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.black,
                              ),
                              Text(
                                'Scanner',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10.0,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    //SizedBox(height: 10.0),
                    Stack(
                      children: [
                        TextFormField(
                          enabled: errorMessage.length == 0 ? true : false,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            errorText: state.errorMessage2,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) => context
                              .read<ShippingOutCubit>()
                              .quantityChanged(num.tryParse(value)),
                          validator: (value) => value.isEmpty
                              ? "enter the product's quantity"
                              : null,
                        ),
                        Positioned(
                          top: 15.0,
                          right: 18.0,
                          child: Column(children: [
                            Text(
                              'Current Stock :',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 10.0,
                              ),
                            ),
                            ((state.productBarCode != null) &&
                                    (errorMessage == ''))
                                ? Text(
                                    state.product.quantity.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10.0,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        onPrimary: Colors.white,
                        shadowColor: Colors.grey,
                      ),
                      onPressed: () => _submitForm(
                        context,
                        state.status == ShippingOutStatus.submitting,
                      ),
                      child: Text('add to cart'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        onPrimary: Colors.white,
                        shadowColor: Colors.grey,
                      ),
                      child: Text('cart (' +
                          state.productsList.length.toString() +
                          ')'),
                      onPressed: () =>
                          Navigator.of(context).pushNamed(CartScreen.routeName),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> codeScanner(BuildContext context) async {
    String code = await ScannerHelper.barcodeScanner(context: context);
    if (code != '-1') {
      context.read<ShippingOutCubit>().productBarcodeChanged(code);

      controller.text = code;
    }
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formkey.currentState.validate() && !isSubmitting) {
      context.read<ShippingOutCubit>().addToCart();
    }
  }
}
