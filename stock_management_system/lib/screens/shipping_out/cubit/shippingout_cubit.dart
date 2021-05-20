import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/products/product_repository.dart';

part 'shippingout_state.dart';

class ShippingOutCubit extends Cubit<ShippingOutState> {
  ProductRepository _productRepository;
  Product product;
  ShippingOutCubit({
    ProductRepository productRepository,
  })  : _productRepository = productRepository,
        super(ShippingOutState.initial());

  /// This function receives a product barcode and
  /// peforms a search for the corresponding product in the database.
  /// If the product is not found,this function emits an error status.
  /// Otherwise it emits this product barcode.
  Future<void> searchProduct(String productBarCode) async {
    final isProductAvailable = await _productRepository.isProductAvailable(
      productBarCode: productBarCode,
    );

    if (isProductAvailable != null) {
      product = isProductAvailable;
      emit(
        state.copyWith(
          productBarCode: productBarCode,
          status: ShippingOutStatus.initial,
        ),
      );
    } else {
      product = isProductAvailable;
      emit(
        state.copyWith(
          failure: Failure(
            message:
                "product barcode *$productBarCode* is not available in the stock.",
          ),
          status: ShippingOutStatus.error,
        ),
      );
    }
  }

  void productBarcodeChanged(String productBarCode) async {
    if (productBarCode.length < 1) {
      emit(
        state.copyWith(
          productBarCode: productBarCode,
          status: ShippingOutStatus.initial,
        ),
      );
    } else {
      await searchProduct(productBarCode);
    }
  }

  void quantityChanged(int value) {
    emit(state.copyWith(quantity: value, status: ShippingOutStatus.initial));
  }

  void reset() {
    emit(ShippingOutState.initial());
  }

  void addTocard() async {
    if (!state.isFormValid || state.status == ShippingOutStatus.submitting) {
      return;
    }

    emit(state.copyWith(status: ShippingOutStatus.submitting));

    if (product != null) {
      await _productRepository.addProductToCart(product: product);
      emit(state.copyWith(status: ShippingOutStatus.success));
    }
  }
}
