import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/helpers/helpers.dart';
import 'package:stock_management_system/screens/shipping_in/cubit/shipping_in_cubit.dart';
import 'package:stock_management_system/screens/shipping_out/cubit/shippingout_cubit.dart';

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShippingOutCubit, ShippingOutState>(
      listener: (context, state) {
        // TODO: implement listener
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
              const SizedBox(height: 28.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  shadowColor: Colors.grey,
                ),
                onPressed: () => _submitForm(
                    context, state.status == ShippingOutStatus.submitting),
                child: Text('add'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> codeScanner(BuildContext context) async {
    String code = await ScannerHelper.barcodeScanner(context: context);
    context.read<ShippingOutCubit>().productBarcodeChanged(code);
    controller.text = code;
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formkey.currentState.validate() && !isSubmitting) {
      context.read<ShippingOutCubit>().addTocard();
    }
  }
}
