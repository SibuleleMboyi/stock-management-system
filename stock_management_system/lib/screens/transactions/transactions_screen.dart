import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/screens/search/search_screen.dart';
import 'package:stock_management_system/screens/transactions/cubit/transactions_cubit.dart';
import 'package:stock_management_system/widgets/widgets.dart';

class TransactionsScreen extends StatelessWidget {
  static const String routeName = '/transaction';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      builder: (context, state) {
        context.read<TransactionsCubit>().transactionsList();

        switch (state.status) {
          case TransactionsStatus.error:
            return Scaffold(
              appBar: AppBar(
                title: Center(child: Text('Error')),
              ),
              body: CenteredText(text: state.failure.message),
            );
          case TransactionsStatus.loading:
            return Scaffold(
              appBar: AppBar(
                  title: Center(child: Text('Historic Transactions')),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ]),
              body: Align(
                child: const CircularProgressIndicator(),
              ),
            );

          case TransactionsStatus.success:
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
                  body: state.transactionsList.isNotEmpty
                      ? StickyHearderGridView(
                          uniqueDates: state.uniqueDates,
                          transactionsSubListFunc: context
                              .read<TransactionsCubit>()
                              .transactionsSubList,
                          transactionPdfUrl: null,
                        )
                      : CenteredText(text: 'No historic transactions yet'),
                ),
              ),
            );

            break;
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
