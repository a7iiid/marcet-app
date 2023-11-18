import 'package:flutter/material.dart';
import 'package:raed/viwe/settings.dart';

import 'home.dart';

class bottomNavigetor extends StatefulWidget {
  const bottomNavigetor({Key? key}) : super(key: key);

  @override
  State<bottomNavigetor> createState() => _bottomNavigetorState();
}

class _bottomNavigetorState extends State<bottomNavigetor> {

  static const List<Widget> _widgetOptions = <Widget>[
    home(),

    setting(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( body:Center(child: _widgetOptions.elementAt(_selectedIndex)),
    bottomNavigationBar:BottomNavigationBar(items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),label: 'Home'),

      BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
          ),label: 'settings')
    ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
    ));
  }
}
