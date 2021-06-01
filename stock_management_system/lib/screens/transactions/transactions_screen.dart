import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/screens/transactions/cubit/transaction_cubit.dart';

/// Contains historical transactions that can be filtered according to the user preferences

class TransactionsScreen extends StatelessWidget {
  static const String routeName = '/transactions';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        print(context.read<TransactionCubit>().transactionPdfs());

        if (state.status == TransactionStatus.error) {
          context.read<TransactionCubit>().reset();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              content: Text(state.failure.message),
            ),
          );
        } else if (state.status == TransactionStatus.success) {
          print(state.transactionsList);
          print('I am tired!');
        }
      },
      builder: (context, state) {
        // context.read<TransactionCubit>().transactionPdfs();
        print(state.transactionsList[2].transactionNumber);
        print('transactionsList lenght: ' +
            state.transactionsList.length.toString());
        return Scaffold(
          appBar: AppBar(
            title: Center(child: Text('PDF View')),
          ),
          body:
              /* PDFView(
              filePath: state.transactionsList[0].transactionPdfUrl,
            ) */
              Center(
                  child: state.status == TransactionStatus.initial
                      ? const CircularProgressIndicator()
                      : Text(state.transactionsList[0].transactionPdfUrl)),
        );
      },
    );
  }
}
