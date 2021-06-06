import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:stock_management_system/widgets/pdfview_page_screen.dart';

class StickyHearderGridView extends StatelessWidget {
  final List<String> uniqueDates;
  final Function transactionsSubListFunc;
  final String transactionPdfUrl;

  const StickyHearderGridView({
    Key key,
    @required this.uniqueDates,
    @required this.transactionsSubListFunc,
    this.transactionPdfUrl = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactionPdfUrl == null
        ? ListView.builder(
            itemCount: uniqueDates.length,
            itemBuilder: (context, index1) {
              return StickyHeader(
                header: Container(
                  height: 50.0,
                  //color: Colors.white,
                  color: Colors.black12,
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                  child: Text(
                    uniqueDates[index1],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                content: Container(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        transactionsSubListFunc(uniqueDate: uniqueDates[index1])
                            .length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      //TODO: make this gesture detector work
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PdfViewPageScreen(
                                transactionPdfUrl: transactionsSubListFunc(
                                        uniqueDate: uniqueDates[index1])[index]
                                    .transactionPdfUrl,
                              ),
                            ),
                          );
                        },
                        child: PDF().fromUrl(
                          transactionsSubListFunc(
                                  uniqueDate: uniqueDates[index1])[index]
                              .transactionPdfUrl,
                          placeholder: (double progress) =>
                              const LinearProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          )
        : PDF().fromUrl(
            transactionPdfUrl,
            placeholder: (double progress) => const LinearProgressIndicator(),
          );
  }
}
