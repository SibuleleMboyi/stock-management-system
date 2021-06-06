import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/screens/search/search_screen.dart';
import 'package:stock_management_system/screens/transactions/cubit/transactions_cubit.dart';
import 'package:stock_management_system/widgets/widgets.dart';

class TransactionsScreen extends StatelessWidget {
  static const String routeName = '/transaction';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionsCubit, TransactionsState>(
      listener: (context, state) {
        if (state.status == TransactionsStatus.success) {
          print('I am tired!');
        }
      },
      builder: (context, state) {
        context.read<TransactionsCubit>().transactionsList();

        return RefreshIndicator(
          onRefresh: () async {
            context.read<TransactionsCubit>().reset();
            context.read<TransactionsCubit>().transactionsList();
            return true;
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                title: Center(child: Text('Historic Transactions')),
                actions: [
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: DataSearch(
                            transactionsList: state.transactionsList,
                            uniqueDates: state.uniqueDates,
                            transactionsSubListFunc: context
                                .read<TransactionsCubit>()
                                .transactionsSubList,
                          ),
                        );
                      })
                ],
              ),
              backgroundColor: Colors.white,
              body: state.status != TransactionsStatus.success
                  ? Center(child: const CircularProgressIndicator())
                  : StickyHearderGridView(
                      uniqueDates: state.uniqueDates,
                      transactionsSubListFunc:
                          context.read<TransactionsCubit>().transactionsSubList,
                      transactionPdfUrl: null,
                    ),
            ),
          ),
        );
      },
    );
  }
}
