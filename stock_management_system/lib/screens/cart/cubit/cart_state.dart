part of 'cart_cubit.dart';

enum CartStatus { initial, submitting, success, error }

@immutable
class CartState extends Equatable {
  final List<Product> productsList;
  final User user;
  final CartStatus status;
  final Failure failure;

  CartState({
    @required this.productsList,
    @required this.user,
    @required this.status,
    @required this.failure,
  });

  @override
  List<Object> get props => [productsList, user, status, failure];

  factory CartState.initial() {
    return CartState(
      productsList: [],
      user: User.empty,
      status: CartStatus.initial,
      failure: Failure(),
    );
  }

  CartState copyWith({
    List<Product> productsList,
    User user,
    CartStatus status,
    Failure failure,
  }) {
    return CartState(
      productsList: productsList ?? this.productsList,
      user: user ?? this.user,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
