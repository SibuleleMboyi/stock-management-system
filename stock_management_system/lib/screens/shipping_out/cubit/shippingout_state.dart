part of 'shippingout_cubit.dart';

enum ShippingOutStatus { initial, submitting, success, error }

@immutable
class ShippingOutState extends Equatable {
  final String productBarCode;
  final int quantity;
  final ShippingOutStatus status;
  final Failure failure;

  ShippingOutState({
    @required this.productBarCode,
    @required this.quantity,
    @required this.status,
    @required this.failure,
  });

  @override
  List<Object> get props => [productBarCode, quantity, status, failure];

  bool get isFormValid => productBarCode.isNotEmpty && quantity != 0;

  factory ShippingOutState.initial() {
    return ShippingOutState(
        productBarCode: null,
        quantity: 0,
        status: ShippingOutStatus.initial,
        failure: Failure());
  }

  ShippingOutState copyWith({
    String productBarCode,
    int quantity,
    ShippingOutStatus status,
    Failure failure,
  }) {
    return ShippingOutState(
      productBarCode: productBarCode ?? this.productBarCode,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
