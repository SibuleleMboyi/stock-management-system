part of 'transaction_cubit.dart';

enum TransactionStatus { initial, loading, success, error }

@immutable
class TransactionState extends Equatable {
  final List<Transaction_> transactionsList;
  final List<Transaction_> transactionsSubList;
  final List<File> pdfs;
  final List<String> uniqueDates;
  final TransactionStatus status;
  final Failure failure;

  TransactionState({
    @required this.transactionsList,
    @required this.transactionsSubList,
    @required this.pdfs,
    @required this.uniqueDates,
    @required this.status,
    @required this.failure,
  });

  @override
  List<Object> get props => [
        transactionsList,
        transactionsSubList,
        pdfs,
        uniqueDates,
        status,
        failure
      ];

  factory TransactionState.initial() {
    return TransactionState(
      transactionsList: [],
      transactionsSubList: [],
      pdfs: [],
      uniqueDates: [],
      status: TransactionStatus.initial,
      failure: Failure(),
    );
  }

  TransactionState copyWith({
    List<Transaction_> transactionsList,
    List<Transaction_> transactionsSubList,
    List<File> pdfs,
    List<String> uniqueDates,
    TransactionStatus status,
    Failure failure,
  }) {
    return TransactionState(
      transactionsList: transactionsList ?? this.transactionsList,
      transactionsSubList: transactionsSubList ?? this.transactionsSubList,
      pdfs: pdfs ?? this.pdfs,
      uniqueDates: uniqueDates ?? this.uniqueDates,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
