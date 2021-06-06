import 'package:flutter/material.dart';
import 'package:stock_management_system/helpers/helpers.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/widgets/widgets.dart';

class DataSearch extends SearchDelegate<String> {
  final List<Transaction_> transactionsList;
  final List<String> uniqueDates;
  final Function transactionsSubListFunc;

  final List<String> recentSearches = [];

  DataSearch({
    @required this.transactionsList,
    @required this.uniqueDates,
    @required this.transactionsSubListFunc,
  });

  // actions for app bar
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.camera_alt_outlined),
          onPressed: () async {
            String code = await ScannerHelper.barcodeScanner(context: context);
            if (code != '-1') {
              query = code;
            }
          }),
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  // leading icon on the left of the app bar
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // shows results when a user selects a choice from the suggestions
  @override
  Widget buildResults(BuildContext context) {
    final list = transactionsList
        .where((element) => element.transactionNumber == query)
        .toList();

    if (recentSearches.length == 6) {
      recentSearches.removeAt(5);
    }
    if (uniqueDates.contains(query)) {
      recentSearches.add(query);
      return StickyHearderGridView(
        uniqueDates: [query],
        transactionsSubListFunc: transactionsSubListFunc,
        transactionPdfUrl: null,
      );
    } else if (list.isNotEmpty) {
      recentSearches.add(list[0].transactionNumber);
      return StickyHearderGridView(
        uniqueDates: [],
        transactionsSubListFunc: transactionsSubListFunc,
        transactionPdfUrl: list[0].transactionPdfUrl,
      );
    }
    return Center(
      child: Text(
        'No results',
        style: TextStyle(fontSize: 18.0, color: Colors.black),
      ),
    );
  }

  // show suggestions when someone types or searches for something
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> list = [];
    transactionsList.forEach((transaction) {
      list.add(transaction.transactionNumber);
    });
    list = list + uniqueDates;
    List<String> suggestionList = query.isEmpty
        ? recentSearches.reversed.toList()
        : list.where((item) => item.startsWith(query)).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          query = suggestionList[index];
          showResults(context);
        },
        leading: Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].substring(0, query.length),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(color: Colors.black26),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  PreferredSize buildBottom(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: Container(
        width: double.infinity,
        color: Colors.black38,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Scan transaction QR Code/BarCode OR'),
              Text('Search by transaction No OR date formmat: dd-mm-yyyy'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ThemeData appBarTheme(context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        color: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        textTheme: const TextTheme(
          headline6: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 15.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
