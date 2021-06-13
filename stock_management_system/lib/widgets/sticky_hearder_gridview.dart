import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:stock_management_system/screens/screens.dart';

class StickyHearderGridView extends StatefulWidget {
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
  _StickyHearderGridViewState createState() => _StickyHearderGridViewState();
}

class _StickyHearderGridViewState extends State<StickyHearderGridView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.transactionPdfUrl == null
        ? ListView.builder(
            itemCount: widget.uniqueDates.length,
            itemBuilder: (context, index1) {
              return StickyHeader(
                header: Container(
                  height: 50.0,
                  color: Colors.black12,
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                  child: Text(
                    widget.uniqueDates[index1],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                content: Container(
                  color: Colors.black12,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget
                        .transactionsSubListFunc(
                            uniqueDate: widget.uniqueDates[index1])
                        .length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onDoubleTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfViewPageScreen(
                                  transactionPdfUrl: widget
                                      .transactionsSubListFunc(
                                          uniqueDate:
                                              widget.uniqueDates[index1])[index]
                                      .transactionPdfUrl,
                                ),
                              ),
                            );
                          },
                          child: PdfWidget(
                            pdfUrl: widget
                                .transactionsSubListFunc(
                                    uniqueDate:
                                        widget.uniqueDates[index1])[index]
                                .transactionPdfUrl,
                          ));
                    },
                  ),
                ),
              );
            },
          )
        : PDF().cachedFromUrl(
            widget.transactionPdfUrl,
            placeholder: (double progress) => const LinearProgressIndicator(
              minHeight: 2.0,
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}

class PdfWidget extends StatefulWidget {
  final String pdfUrl;

  const PdfWidget({
    Key key,
    @required this.pdfUrl,
  }) : super(key: key);

  @override
  _PdfWidgetState createState() => _PdfWidgetState();
}

class _PdfWidgetState extends State<PdfWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: PDF().fromUrl(
        widget.pdfUrl,
        //errorWidget: ,
        placeholder: (double progress) => Align(
          alignment: Alignment.center,
          child: const LinearProgressIndicator(
            minHeight: 2.0,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
