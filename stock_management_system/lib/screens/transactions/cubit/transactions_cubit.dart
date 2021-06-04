import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/repositories.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final ProductRepository _productRepository;

  TransactionsCubit({
    @required ProductRepository productRepository,
  })  : _productRepository = productRepository,
        super(TransactionsState.initial());

  void transactionsList() async {
    if (state.status == TransactionsStatus.success) return;
    emit(state.copyWith(status: TransactionsStatus.loading));

    try {
      final transactions = await _productRepository.fetchTransactions();
      final dates =
          transactions.map((transaction) => transaction.date).toSet().toList();
      //productsSubList(transactions: transactions);
      emit(state.copyWith(
        status: TransactionsStatus.success,
        transactionsList: transactions,
        uniqueDates: dates,
      ));
      print(dates);
    } catch (err) {
      state.copyWith(
          status: TransactionsStatus.error,
          failure: const Failure(message: 'We are unable to load your feed.'));
    }

    //print(state.transactionsList[0].transactionPdfUrl);
  }

  List<Transaction_> transactionsSubList({@required String uniqueDate}) {
    final list = state.transactionsList
        .where((transaction) => transaction.date == uniqueDate)
        .toList();

    return list;
  }

  void reset() => emit(TransactionsState.initial());
}
