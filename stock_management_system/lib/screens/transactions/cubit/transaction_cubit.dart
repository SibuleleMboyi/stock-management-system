import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/repositories.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final ProductRepository _productRepository;
  final StorageRepository _storageRepository;

  TransactionCubit({
    @required ProductRepository productRepository,
    @required StorageRepository storageRepository,
  })  : _productRepository = productRepository,
        _storageRepository = storageRepository,
        super(TransactionState.initial());

  void productsList() async {
    try {
      final transactions = await _productRepository.fetchTransactions();
      //print(transactions);
      emit(state.copyWith(
        status: TransactionStatus.success,
        transactionsList: transactions,
      ));
    } on Failure catch (err) {
      emit(
        state.copyWith(
          status: TransactionStatus.error,
          failure: Failure(message: err.message),
        ),
      );
      //print(err);
    }
  }

  Future<void> transactionPdfs() async {
    return await _productRepository.fetchTransactions();
  }

/*   Future<void> transactionPdfs() async {
    // TODO :: create a list and assign it to 'pdfs' list

    List<File> files;
    state.transactionsList.forEach((transaction) async {
      final pdfFile = await _storageRepository.pdfs(transaction: transaction);
      files.add(pdfFile);
    }); 

    emit(state.copyWith(
      pdfs: files,
      status: TransactionStatus.success,
    ));

    //return ;
  }*/

  void reset() => emit(TransactionState.initial());
}
