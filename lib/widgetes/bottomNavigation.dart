import 'package:flutter/material.dart';
import 'package:money_management_flutter/screens/screenHome.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedValueNotifier,
      builder: (BuildContext ctx, int newvalue, Widget?_){
        return BottomNavigationBar(
      currentIndex: newvalue,
      unselectedItemColor: Colors.grey[400],
      onTap: (newindex){
        ScreenHome.selectedValueNotifier.value = newindex;
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'TRANSACTION'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'CATEGORY'),
      ],
    );
      },
    );
  }
}
