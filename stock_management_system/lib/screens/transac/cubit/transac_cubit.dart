import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/repositories.dart';

part 'transac_state.dart';

class TransacCubit extends Cubit<TransacState> {
  final ProductRepository _productRepository;

  TransacCubit({
    @required ProductRepository productRepository,
  })  : _productRepository = productRepository,
        super(TransacState.initial());

  void productsList() async {
    if (state.status == TransacStatus.success) return;

    emit(state.copyWith(status: TransacStatus.loading));
    final transactions = await _productRepository.fetchTransactions();

    emit(state.copyWith(
      status: TransacStatus.success,
      transactionsList: transactions,
    ));
    //print(state.transactionsList[0].transactionPdfUrl);
  }
}
