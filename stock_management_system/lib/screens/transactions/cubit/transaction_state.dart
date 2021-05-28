part of 'transaction_cubit.dart';

@immutable
class TransactionState extends Equatable {
  final List<Product> productsList;

  TransactionState({
    @required this.productsList,
  });

  @override
  List<Object> get props => [productsList];

  factory TransactionState.initial() {
    return TransactionState(
      productsList: [],
    );
  }
}
