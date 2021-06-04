import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:stock_management_system/screens/transactions/cubit/transactions_cubit.dart';

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
                ),
                backgroundColor: Colors.white,
                body: state.status != TransactionsStatus.success
                    ? Center(child: const CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: state.uniqueDates.length,
                        itemBuilder: (context, index1) {
                          return StickyHeader(
                            header: Container(
                              height: 50.0,
                              //color: Colors.white,
                              color: Colors.black12,
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                              child: Text(
                                state.uniqueDates[index1],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            content: Container(
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: context
                                      .read<TransactionsCubit>()
                                      .transactionsSubList(
                                          uniqueDate: state.uniqueDates[index1])
                                      .length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 2,
                                  ),
                                  itemBuilder: (context, index) {
                                    return PDF().fromUrl(
                                      context
                                          .read<TransactionsCubit>()
                                          .transactionsSubList(
                                              uniqueDate: state
                                                  .uniqueDates[index1])[index]
                                          .transactionPdfUrl,
                                      placeholder: (double progress) =>
                                          const LinearProgressIndicator(),
                                    );
                                  }),
                            ),
                          );
                        },
                      )),
          ),
        );
      },
    );
  }
}
