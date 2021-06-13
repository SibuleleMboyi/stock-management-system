import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/products/product_repository.dart';
import 'package:stock_management_system/repositories/repositories.dart';

part 'shipping_in_state.dart';

class ShippingInCubit extends Cubit<ShippingInState> {
  final ProductRepository _productRepository;

  ShippingInCubit({
    @required ProductRepository productRepository,
  })  : _productRepository = productRepository,
        super(ShippingInState.initial());

  /// This function receives a product barcode and
  /// peforms a search for the corresponding product in the database.
  /// If the product is found,this function emits an error status.
  /// Otherwise it emits this product barcode.
  Future<void> searchProduct(String productBarCode) async {
    emit(
      state.copyWith(
        status: ShippingInStatus.initial,
      ),
    );

    print(productBarCode);
    final isProductAvailable = await _productRepository.isProductAvailable(
      productBarCode: productBarCode,
    );

    if (isProductAvailable == null) {
      emit(
        state.copyWith(
          productBarCode: productBarCode,
          isEnabled: false,
          errorMessage: '',
          status: ShippingInStatus.initial,
        ),
      );
    } else {
      emit(
        state.copyWith(
          productBarCode: productBarCode,
          isEnabled: true,
          errorMessage:
              "product barcode '$productBarCode' is already in stock.",
          status: ShippingInStatus.error,
        ),
      );
    }
  }

  /// While typing(or scanning) product barcode, this function contiously checks if it already exists
  /// in the database by calling 'searchProduct()' function.
  /// Check description of 'searchProduct()' function.
  /// Because a user can choose to cancel the typed in barcode until the field is empty.
  /// To avoid searching for an empty product id (productBarcode) in the database(it crashes the App).
  /// The null  productBarCode value is emitted and this will be handled by the Form validation method
  /// when submitting the form.

  void productBarcodeChanged(String productBarCode) async {
    if (productBarCode.length < 1) {
      return;
    } else {
      await searchProduct(productBarCode);
    }
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
    if (!state.isFormValid || state.status == ShippingInStatus.submitting) {
      return;
    }

    emit(state.copyWith(status: ShippingInStatus.submitting));

    try {
      final product = Product(
        productBarCode: state.productBarCode,
        productName: state.productName,
        productBrand: state.productBrand,
        quantity: state.quantity,
        price: state.price,
      );

      await _productRepository.addNewStockProduct(product: product);
      emit(state.copyWith(status: ShippingInStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(
          status: ShippingInStatus.error,
          failure: Failure(message: err.message)));
    }
  }
}
