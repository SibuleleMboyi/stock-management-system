import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/helpers/helpers.dart';
import 'package:stock_management_system/repositories/repositories.dart';
import 'package:stock_management_system/screens/shipping_out/cubit/shippingout_cubit.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit_product';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => BlocProvider<ShippingOutCubit>(
              create: (_) => ShippingOutCubit(
                productRepository: context.read<ProductRepository>(),
              ),
              child: EditProductScreen(),
            ));
  }

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String errorMessage = '';

  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text('Edit Product')),
          ),
          body: SingleChildScrollView(
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 30.0, 12.0, 12.0),
                child: BlocConsumer<ShippingOutCubit, ShippingOutState>(
                  listener: (context, state) {
                    if (state.status == ShippingOutStatus.success) {
                      _formkey.currentState.reset();
                      controller.clear();
                      context.read<ShippingOutCubit>().reset();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 3),
                          content: const Text('Product successfully edited'),
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
                    return Form(
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
                                      Icons.home,
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
                          SizedBox(height: 16.0),
                          Stack(
                            children: [
                              TextFormField(
                                enabled:
                                    errorMessage.length == 0 ? true : false,
                                decoration: InputDecoration(
                                  labelText: 'Quantity',
                                  //errorText: '*Required',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (value) => context
                                    .read<ShippingOutCubit>()
                                    .updateProductQuantity(num.tryParse(value)),
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
                          SizedBox(height: 16.0),
                          Stack(
                            children: [
                              TextFormField(
                                enabled:
                                    errorMessage.length == 0 ? true : false,
                                decoration: InputDecoration(
                                  labelText: 'Price',
                                  //errorText: '*Required',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (value) => context
                                    .read<ShippingOutCubit>()
                                    .updateProductPrice(num.tryParse(value)),
                                validator: (value) => value.isEmpty
                                    ? "enter the product's quantity"
                                    : null,
                              ),
                              Positioned(
                                top: 15.0,
                                right: 18.0,
                                child: Column(children: [
                                  Text(
                                    'Current Stock Price:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  ((state.productBarCode != null) &&
                                          (errorMessage == ''))
                                      ? Text(
                                          'R' + state.product.price.toString(),
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
                          SizedBox(height: 16.0),
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
                            child: Text('submit'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          )),
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
      context.read<ShippingOutCubit>().editProduct();
    }
  }
}
