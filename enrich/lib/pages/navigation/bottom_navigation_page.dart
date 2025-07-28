import 'package:enrich/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../settings_page.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    //ExtraIncomePage(),
    HomePage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.black,
          iconSize: 33,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            /*
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_outlined),
              label: "",
            ),*/
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "",
            ),
          ]),
      body: Stack(children: [
        _pages[_currentIndex]
      ]),
    );
  }
}
