part of 'transactions_cubit.dart';

enum TransactionsStatus { initial, loading, success, error }

@immutable
class TransactionsState extends Equatable {
  final List<Transaction_> transactionsList;
  final List<Transaction_> transactionsSubList;
  final List<File> pdfs;
  final List<String> uniqueDates;
  final TransactionsStatus status;
  final Failure failure;

  TransactionsState({
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

  factory TransactionsState.initial() {
    return TransactionsState(
      transactionsList: [],
      transactionsSubList: [],
      pdfs: [],
      uniqueDates: [],
      status: TransactionsStatus.initial,
      failure: Failure(),
    );
  }

  TransactionsState copyWith({
    List<Transaction_> transactionsList,
    List<Transaction_> transactionsSubList,
    List<File> pdfs,
    List<String> uniqueDates,
    TransactionsStatus status,
    Failure failure,
  }) {
    return TransactionsState(
      transactionsList: transactionsList ?? this.transactionsList,
      transactionsSubList: transactionsSubList ?? this.transactionsSubList,
      pdfs: pdfs ?? this.pdfs,
      uniqueDates: uniqueDates ?? this.uniqueDates,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
