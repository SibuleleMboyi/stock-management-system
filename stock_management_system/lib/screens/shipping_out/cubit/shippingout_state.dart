part of 'shippingout_cubit.dart';

enum ShippingOutStatus { initial, submitting, success, error }

@immutable
class ShippingOutState extends Equatable {
  final Product product;
  final String productBarCode;
  final int quantity;
  final List<Product> productsList;
  final ShippingOutStatus status;

  final Failure failure;

  ShippingOutState({
    @required this.product,
    @required this.productBarCode,
    @required this.quantity,
    @required this.productsList,
    @required this.status,
    @required this.failure,
  });

  @override
  List<Object> get props =>
      [product, productBarCode, quantity, productsList, status, failure];

  bool get isFormValid => productBarCode.isNotEmpty && quantity != 0;

  factory ShippingOutState.initial() {
    return ShippingOutState(
      product: null,
      productBarCode: null,
      quantity: 0,
      productsList: [],
      status: ShippingOutStatus.initial,
      failure: Failure(),
    );
  }

  ShippingOutState copyWith({
    Product product,
    String productBarCode,
    int quantity,
    List<Product> productsList,
    ShippingOutStatus status,
    Failure failure,
  }) {
    return ShippingOutState(
      product: product ?? this.product,
      productBarCode: productBarCode ?? this.productBarCode,
      quantity: quantity ?? this.quantity,
      productsList: productsList ?? this.productsList,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
