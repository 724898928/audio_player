import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<BottomNavigationBarItem> items;
  final ValueChanged<int> onTap;

  CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: EdgeInsets.only(left: 30, top: 0, bottom: 0, right: 30),
      height: 55,
      color: Colors.black12,
      notchMargin: 3,
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          var icon = (item.icon as Icon).icon;
          return GestureDetector(
            onTap: () => onTap(items.indexOf(item)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 25,
                  color: selectedIndex == items.indexOf(item)
                      ? Colors.blue
                      : Colors.grey,
                ),
                Text(
                  item.label!,
                  style: TextStyle(
                      color: selectedIndex == items.indexOf(item)
                          ? Colors.blue
                          : Colors.grey,
                      fontSize: 11),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
