import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/repositories.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final ProductRepository _productRepository;

  TransactionCubit({
    @required ProductRepository productRepository,
  })  : _productRepository = productRepository,
        super(TransactionState.initial());

  void transactionsList() async {
    if (state.status == TransactionStatus.success) return;
    emit(state.copyWith(status: TransactionStatus.loading));

    try {
      final transactions = await _productRepository.fetchTransactions();
      final dates =
          transactions.map((transaction) => transaction.date).toSet().toList();
      //productsSubList(transactions: transactions);
      emit(state.copyWith(
        status: TransactionStatus.success,
        transactionsList: transactions,
        uniqueDates: dates,
      ));
      print(dates);
    } catch (err) {
      state.copyWith(
          status: TransactionStatus.error,
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

  void reset() => emit(TransactionState.initial());
}
