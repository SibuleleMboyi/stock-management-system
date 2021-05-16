import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/products/product_repository.dart';

part 'shippingout_state.dart';

class ShippingOutCubit extends Cubit<ShippingOutState> {
  ProductRepository _productRepository;
  ShippingOutCubit({
    ProductRepository productRepository,
  })  : _productRepository = productRepository,
        super(ShippingOutState.initial());

  void productBarcodeChanged(String value) {
    emit(state.copyWith(
        productBarCode: value, status: ShippingOutStatus.initial));
  }

  void quantityChanged(int value) {
    emit(state.copyWith(quantity: value, status: ShippingOutStatus.initial));
  }

  void addTocard() async {
    if (!state.isFormValid || state.status == ShippingOutStatus.submitting) {
      return;
    }

    emit(state.copyWith(status: ShippingOutStatus.submitting));

    try {
      final product = Product(
        productBarCode: state.productBarCode,
        quantity: state.quantity,
      );
      await _productRepository.addToCart(product: product);
      emit(state.copyWith(status: ShippingOutStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(
          status: ShippingOutStatus.error,
          failure: Failure(message: err.message)));
    }
  }
}
