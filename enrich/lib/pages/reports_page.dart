import 'package:enrich/widgets/texts/little_text.dart';
import 'package:flutter/material.dart';

import '../widgets/texts/title_text.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new, color: Colors.black,),
              SizedBox(width: 2,),
              const LittleText(
                text: 'Voltar',
                fontSize: 14,
                underlined: true,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
            child: TitleText(
              text: 'Relatórios Financeiros',
              fontSize: 21,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  onTap: () {},
                  title: LittleText(
                    text: 'Agosto de 2024',
                    fontSize: 14,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.download_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {},
                  ),
                ),
                ListTile(
              onTap: () {},
              title: LittleText(
                text: 'Julho de 2024',
                fontSize: 14,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.download_rounded,
                  color: Theme.of(context).colorScheme.primary
                ),
              onPressed: () {},),
            ),
            ListTile(
              onTap: () {},
              title: LittleText(
                text: 'Junho de 2024',
                fontSize: 14,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.download_rounded,
                  color: Theme.of(context).colorScheme.primary
                ),
              onPressed: () {},),
            ),
            ListTile(
              onTap: () {},
              title: LittleText(
                text: 'Maio de 2024',
                fontSize: 14,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.download_rounded,
                  color: Theme.of(context).colorScheme.primary
                ),
              onPressed: () {},),
            ),
            ListTile(
              onTap: () {},
              title: LittleText(
                text: 'Abril de 2024',
                fontSize: 14,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.download_rounded,
                  color: Theme.of(context).colorScheme.primary
                ),
              onPressed: () {},),
            ),
            ListTile(
              onTap: () {},
              title: LittleText(
                text: 'Março de 2024',
                fontSize: 14,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.download_rounded,
                  color: Theme.of(context).colorScheme.primary
                ),
              onPressed: () {},),
            ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
