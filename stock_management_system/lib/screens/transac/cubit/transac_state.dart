part of 'transac_cubit.dart';

enum TransacStatus { initial, loading, success, error }

@immutable
class TransacState extends Equatable {
  final List<Transaction_> transactionsList;
  final List<File> pdfs;
  final TransacStatus status;
  final Failure failure;

  TransacState({
    @required this.transactionsList,
    @required this.pdfs,
    @required this.status,
    @required this.failure,
  });

  @override
  List<Object> get props => [transactionsList, pdfs, status, failure];

  factory TransacState.initial() {
    return TransacState(
      transactionsList: [],
      pdfs: [],
      status: TransacStatus.initial,
      failure: Failure(),
    );
  }

  TransacState copyWith({
    List<Transaction_> transactionsList,
    List<File> pdfs,
    TransacStatus status,
    Failure failure,
  }) {
    return TransacState(
      transactionsList: transactionsList ?? this.transactionsList,
      pdfs: pdfs ?? this.pdfs,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
