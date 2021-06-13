part of 'shipping_in_cubit.dart';

enum ShippingInStatus { initial, submitting, success, error }

@immutable
class ShippingInState extends Equatable {
  final String productBarCode;
  final String productName;
  final String productBrand;
  final int quantity;
  final int price;
  final String errorMessage;
  final bool isEnabled;
  final ShippingInStatus status;
  final Failure failure;

  ShippingInState({
    @required this.productBarCode,
    @required this.productName,
    @required this.productBrand,
    @required this.quantity,
    @required this.price,
    @required this.errorMessage,
    @required this.isEnabled,
    @required this.status,
    @required this.failure,
  });

  bool get isFormValid =>
      productBarCode.isNotEmpty &&
      productName.isNotEmpty &&
      productBrand.isNotEmpty &&
      quantity != 0 &&
      price != 0;

  factory ShippingInState.initial() {
    return ShippingInState(
      productBarCode: null,
      productName: null,
      productBrand: null,
      quantity: 0,
      price: 0,
      errorMessage: null,
      isEnabled: true,
      status: ShippingInStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        productBarCode,
        productName,
        productBrand,
        quantity,
        price,
        errorMessage,
        isEnabled,
        status,
        failure,
      ];

  ShippingInState copyWith({
    String productBarCode,
    String productName,
    String productBrand,
    int quantity,
    int price,
    String errorMessage,
    bool isEnabled,
    ShippingInStatus status,
    Failure failure,
  }) {
    return ShippingInState(
      productBarCode: productBarCode ?? this.productBarCode,
      productName: productName ?? this.productName,
      productBrand: productBrand ?? this.productBrand,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      errorMessage: errorMessage ?? this.errorMessage,
      isEnabled: isEnabled ?? this.isEnabled,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
