import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:stock_management_system/screens/transac/cubit/transac_cubit.dart';

class Transac extends StatelessWidget {
  static const String routeName = '/transac';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransacCubit, TransacState>(
      listener: (context, state) {
        //context.read<TransacCubit>().productsList();
        if (state.status == TransacStatus.success) {
          print(state.transactionsList[0].transactionPdfUrl);
          print('I am tired!');
        } else {
          print('Nooooooooot I am tired!');
        }
      },
      builder: (context, state) {
        //print('mmmhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh' + state.status.toString());
        //print(state.transactionsList[0].transactionPdfUrl);
        context.read<TransacCubit>().productsList();
        return Scaffold(
          appBar: AppBar(
            title: Center(child: Text('PDF View')),
          ),
          body:
              /* PDFView(
              filePath: state.transactionsList[0].transactionPdfUrl,
            ) */
              Center(
            child: state.status == TransacStatus.initial
                ? const CircularProgressIndicator()
                : PDF().fromUrl(
                    state.transactionsList[3].transactionPdfUrl,
                    placeholder: (double progress) =>
                        const CircularProgressIndicator(),
                  ),
          ),
        );
      },
    );
  }
}
