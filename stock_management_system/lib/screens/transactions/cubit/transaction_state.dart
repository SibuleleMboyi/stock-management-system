part of 'transaction_cubit.dart';

enum TransactionStatus { initial, loading, success, error }

@immutable
class TransactionState extends Equatable {
  final List<Transaction_> transactionsList;
  final List<File> pdfs;
  final TransactionStatus status;
  final Failure failure;

  TransactionState({
    @required this.transactionsList,
    @required this.pdfs,
    @required this.status,
    @required this.failure,
  });

  @override
  List<Object> get props => [transactionsList, pdfs, failure, status];

  factory TransactionState.initial() {
    return TransactionState(
      transactionsList: [],
      pdfs: [],
      status: TransactionStatus.initial,
      failure: Failure(),
    );
  }

  TransactionState copyWith({
    List<Transaction_> transactionsList,
    List<File> pdfs,
    TransactionStatus status,
    Failure failure,
  }) {
    return TransactionState(
      transactionsList: transactionsList ?? this.transactionsList,
      pdfs: pdfs ?? this.pdfs,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
