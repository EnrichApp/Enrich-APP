import 'package:enrich/pages/home_page.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

import '../extra_income_page.dart';
import '../settings_page.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _currentIndex = 1;

  final List<Widget> _pages = const [
    ExtraIncomePage(),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_outlined),
              label: "",
            ),
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
        _pages[_currentIndex],
        if (_currentIndex == 1) ...[
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: TitleText(text: 'Sair'),
                          content: LittleText(
                            text:
                                "Você deseja realmente voltar para a tela de login?",
                                textAlign: TextAlign.left,
                            fontSize: 15,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: TitleText(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.surface,
                                text: "Cancelar"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacementNamed(
                                    '/');
                              },
                              child: TitleText(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary,
                                text: "Sim"),
                            ),
                          ],
                        );
                      });
                },
                child: Container(
                  child: Row(children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Sair',
                      style: TextStyle(color: Colors.black),
                    )
                  ]),
                )),
          ),
        ]
      ]),
    );
  }
}
