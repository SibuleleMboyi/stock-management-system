import 'package:flutter/material.dart';
import 'package:stock_management_system/screens/nav/enums/enums.dart';

class BottomNavBar extends StatelessWidget {
  final Map<BottomNavItem, List> items;
  final BottomNavItem selectedItem;
  final Function(int) onTap;

  const BottomNavBar({
    Key key,
    this.items,
    this.selectedItem,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      //elevation: 2.0,
      selectedItemColor: Theme.of(context).primaryColor,
      selectedFontSize: 12.0,
      unselectedItemColor: Colors.grey,
      currentIndex: BottomNavItem.values.indexOf(selectedItem),
      onTap: onTap,
      items: items
          .map(
            (item, list) => MapEntry(
              item,
              BottomNavigationBarItem(
                label: list[1],
                icon: Icon(list[0], size: 30.0),
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
