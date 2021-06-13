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
          isEnabled: false,
          errorMessage1: '',
          productBarCode: productBarCode,
          status: ShippingOutStatus.initial,
        ),
      );
    } else {
      emit(
        state.copyWith(
          product: isProductAvailable,
          isEnabled: true,
          errorMessage1: 'Product is not in stock',
          status: ShippingOutStatus.error,
        ),
      );
    }
  }

  void productBarcodeChanged(String productBarCode) async {
    print(productBarCode);
    if (productBarCode.length < 1) {
      emit(state.copyWith(
        productBarCode: '',
        status: ShippingOutStatus.error,
      ));
    } else {
      await searchProduct(productBarCode);
    }
  }

  void updateProductPrice(int value) {
    emit(state.copyWith(price: value, status: ShippingOutStatus.initial));
  }

  void updateProductQuantity(int value) {
    emit(state.copyWith(quantity: value, status: ShippingOutStatus.initial));
  }

  void quantityChanged(int value) {
    if (state.product.quantity >= value) {
      emit(
        state.copyWith(
          quantity: value,
          errorMessage2: '',
          status: ShippingOutStatus.initial,
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorMessage2: 'Quantity exceeded the stock',
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
    if (!state.isFormValid ||
        state.status == ShippingOutStatus.submitting ||
        state.status == ShippingOutStatus.error) {
      return;
    }

    emit(state.copyWith(status: ShippingOutStatus.submitting));

    try {
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
    } on Failure catch (err) {
      emit(state.copyWith(
          status: ShippingOutStatus.error,
          failure: Failure(message: err.message)));
    }
  }

  void editProduct() async {
    if (state.quantity == 0 && state.price == 0) {
      return;
    }
    print(state.product);
    final product = state.product.copyWith(
      quantity: state.quantity != 0
          ? state.quantity + state.product.quantity
          : state.product.quantity,
      price: state.price != 0 ? state.price : state.product.price,
    );
    print('Break::::::::');
    print(product);
    try {
      emit(state.copyWith(status: ShippingOutStatus.submitting));
      await _productRepository.updateStockProduct(product: product);
      emit(state.copyWith(status: ShippingOutStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(
          status: ShippingOutStatus.error,
          failure: Failure(message: err.message)));
    }
  }

  void reset() {
    emit(ShippingOutState.initial());
  }
}
