import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/screens/shipping_in/cubit/shipping_in_cubit.dart';
import 'package:stock_management_system/widgets/widgets.dart';

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController controller = TextEditingController();

  String productBarCod = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShippingInCubit, ShippingInState>(
      listener: (context, state) {
        if (state.status == ShippingInStatus.success) {
          _formkey.currentState.reset();
          controller.clear();
          context.read<ShippingInCubit>().reset();
        } else if (state.status == ShippingInStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
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
                      //errorText: '*Required',
                    ),
                    controller: controller,
                    onChanged: (value) => context
                        .read<ShippingInCubit>()
                        .productBarcodeChanged(value),
                    validator: (value) => value.isEmpty
                        ? "enter or scan the product's barcode"
                        : null,
                  ),
                  Positioned(
                    top: 8.0,
                    right: 18.0,
                    child: TextButton(
                      onPressed: () => barcodeScanner(context),
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  //errorText: '*Required',
                ),
                onChanged: (value) =>
                    context.read<ShippingInCubit>().productNameChanged(value),
                validator: (value) =>
                    value.isEmpty ? "enter the product's name" : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Product Brand',
                  //errorText: '*Required',
                ),
                onChanged: (value) =>
                    context.read<ShippingInCubit>().productBrandChanged(value),
                validator: (value) =>
                    value.isEmpty ? "enter the product's brand" : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  //errorText: '*Required',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => context
                    .read<ShippingInCubit>()
                    .quantityChanged(num.tryParse(value)),
                validator: (value) =>
                    value.isEmpty ? "enter the product's quantity" : null,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                  //errorText: '*Required',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => context
                    .read<ShippingInCubit>()
                    .priceChanged(num.tryParse(value)),
                validator: (value) =>
                    value.isEmpty ? "enter the product's price" : null,
              ),
              const SizedBox(height: 28.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  shadowColor: Colors.grey,
                ),
                onPressed: () => _submitForm(
                    context, state.status == ShippingInStatus.submitting),
                child: Text('add'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> barcodeScanner(BuildContext context) async {
    try {
      final String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'cancel',
        true,
        ScanMode.BARCODE,
      );

      if (barcodeScanRes != null) {
        context.read<ShippingInCubit>().productBarcodeChanged(barcodeScanRes);
        controller.text = barcodeScanRes;
      }
    } on Failure catch (err) {
      //context.read<ShippingInCubit>().onFailure(err);
      print(' FJHSDFJHSDFJH  ASDHFJSHDFJSD   DSJHFJSDH' + '$err');
    }
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formkey.currentState.validate() && !isSubmitting) {
      context.read<ShippingInCubit>().addNewStock();
    }
  }
}
