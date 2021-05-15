import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/products/product_repository.dart';

part 'shipping_in_state.dart';

class ShippingInCubit extends Cubit<ShippingInState> {
  final ProductRepository _productRepository;

  ShippingInCubit({ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ShippingInState.initial());

  void productBarcodeChanged(String value) {
    emit(state.copyWith(
        productBarCode: value, status: ShippingInStatus.initial));
  }

  void productNameChanged(String value) {
    emit(state.copyWith(productName: value, status: ShippingInStatus.initial));
  }

  void productBrandChanged(String value) {
    emit(state.copyWith(productBrand: value, status: ShippingInStatus.initial));
  }

  void quantityChanged(int value) {
    emit(state.copyWith(quantity: value, status: ShippingInStatus.initial));
  }

  void priceChanged(int value) {
    emit(state.copyWith(price: value, status: ShippingInStatus.initial));
  }

  void reset() {
    emit(ShippingInState.initial());
  }

  void addNewStock() async {
    /*if (!state.isFormValid || state.status == ShippingInStatus.submitting) {
      return;
    }*/

    print('Updated Values :::::::::::::::::');
    print(state.productBarCode);
    print(state.productName);
    print(state.productBrand);
    print(state.quantity);
    print(state.price);

    emit(state.copyWith(status: ShippingInStatus.submitting));

    try {
      final product = Product(
        productBarCode: state.productBarCode,
        productName: state.productName,
        productBrand: state.productName,
        quantity: state.quantity,
        price: state.price,
      );
      await _productRepository.addNewStockProduct(product: product);
      emit(state.copyWith(status: ShippingInStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: ShippingInStatus.error));
    }
  }
}
