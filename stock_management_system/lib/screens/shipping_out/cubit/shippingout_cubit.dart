import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/products/product_repository.dart';

part 'shippingout_state.dart';

class ShippingOutCubit extends Cubit<ShippingOutState> {
  final ProductRepository _productRepository;
  //Product product;
  ShippingOutCubit({
    @required ProductRepository productRepository,
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
      emit(
        state.copyWith(
          product: isProductAvailable,
          productBarCode: productBarCode,
          status: ShippingOutStatus.initial,
        ),
      );
    } else {
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

  void productBarcodeChanged(String value) async {
    if (value.length == 0) {
      emit(
        state.copyWith(
          productBarCode: value,
          status: ShippingOutStatus.initial,
        ),
      );
    } else {
      await searchProduct(value);
    }
  }

  void quantityChanged(int value) {
    if (state.product.quantity >= value) {
      emit(state.copyWith(quantity: value, status: ShippingOutStatus.initial));
    } else {
      emit(
        state.copyWith(
          failure: Failure(message: 'Quantity exceeded the stock'),
          status: ShippingOutStatus.error,
        ),
      );
    }
  }

/*   Future<void> availableProducts() async {
    List<Product> availableProducts =
        await _productRepository.availableProducts();
  } */

  Future<void> productsFromCart() async {
    List<Product> productsList =
        await _productRepository.fetchProductsFromCart();

    emit(state.copyWith(productsList: productsList));
  }

  void addToCart() async {
    if (!state.isFormValid || state.status == ShippingOutStatus.submitting) {
      return;
    }

    emit(state.copyWith(status: ShippingOutStatus.submitting));

    if (state.product != null) {
      final product = Product(
        productBarCode: state.product.productBarCode,
        productName: state.product.productName,
        productBrand: state.product.productBrand,
        price: state.product.price,
        quantity: state.quantity,
      );
      await _productRepository.addProductToCart(product: product);

      emit(state.copyWith(status: ShippingOutStatus.success));
    }
  }

  void reset() {
    emit(ShippingOutState.initial());
  }
}
