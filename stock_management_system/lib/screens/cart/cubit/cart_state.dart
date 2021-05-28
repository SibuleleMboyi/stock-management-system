part of 'cart_cubit.dart';

enum CartStatus { initial, sumitted, success, error }

@immutable
class CartState extends Equatable {
  final List<Product> productsList;
  final User user;

  CartState({
    @required this.productsList,
    @required this.user,
  });

  @override
  List<Object> get props => [productsList, user];

  factory CartState.initial() {
    return CartState(
      productsList: [],
      user: User.empty,
    );
  }

  CartState copyWith({
    List<Product> productsList,
    User user,
  }) {
    return CartState(
      productsList: productsList ?? this.productsList,
      user: user ?? this.user,
    );
  }
}
