part of 'shippingout_cubit.dart';

enum ShippingOutStatus { initial, submitting, success, error }

@immutable
class ShippingOutState extends Equatable {
  final Product product;
  final String productBarCode;
  final String errorMessage2;
  final int quantity;
  final int price;
  final List<Product> productsList;
  final ShippingOutStatus status;

  final Failure failure;

  ShippingOutState({
    @required this.product,
    @required this.productBarCode,
    @required this.errorMessage2,
    @required this.quantity,
    @required this.price,
    @required this.productsList,
    @required this.status,
    @required this.failure,
  });

  @override
  List<Object> get props => [
        product,
        productBarCode,
        quantity,
        errorMessage2,
        price,
        productsList,
        status,
        failure
      ];

  bool get isFormValid => productBarCode.isNotEmpty && quantity != 0;

  factory ShippingOutState.initial() {
    return ShippingOutState(
      product: null,
      productBarCode: null,
      errorMessage2: null,
      quantity: 0,
      price: 0,
      productsList: [],
      status: ShippingOutStatus.initial,
      failure: Failure(),
    );
  }

  ShippingOutState copyWith({
    Product product,
    String productBarCode,
    String errorMessage2,
    int quantity,
    int price,
    List<Product> productsList,
    ShippingOutStatus status,
    Failure failure,
  }) {
    return ShippingOutState(
      product: product ?? this.product,
      productBarCode: productBarCode ?? this.productBarCode,
      errorMessage2: errorMessage2 ?? this.errorMessage2,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      productsList: productsList ?? this.productsList,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
