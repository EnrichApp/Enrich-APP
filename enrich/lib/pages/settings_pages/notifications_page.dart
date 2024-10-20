import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class NotificationPreferencesPage extends StatefulWidget {
  const NotificationPreferencesPage({super.key});

  @override
  _NotificationPreferencesPageState createState() =>
      _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState
    extends State<NotificationPreferencesPage> {
  // Variáveis de estado para controlar o status dos switches
  bool isInvestReminderOn = true;
  bool isSavingsReminderOn = false;
  bool isPlanningReminderOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, // Altere para a cor desejada
        ),
        title: const TitleText(
          text: "Preferências de Notificações",
          color: Colors.black,
          fontSize: 16,
        ),
        backgroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Opção 1: Notificação para lembrar de Investir
            _buildNotificationOption(
              'Notificação para lembrar de Investir',
              isInvestReminderOn,
              (bool value) {
                setState(() {
                  isInvestReminderOn = value;
                });
              },
            ),
            const Divider(),

            // Opção 2: Notificação para lembrar de informar que guardou dinheiro na reserva
            _buildNotificationOption(
              'Notificação para lembrar de informar que guardou dinheiro na reserva',
              isSavingsReminderOn,
              (bool value) {
                setState(() {
                  isSavingsReminderOn = value;
                });
              },
            ),
            const Divider(),

            // Opção 3: Notificação para verificar Planejamento financeiro
            _buildNotificationOption(
              'Notificação para verificar Planejamento financeiro',
              isPlanningReminderOn,
              (bool value) {
                setState(() {
                  isPlanningReminderOn = value;
                });
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  // Função para construir as opções de notificação com switch
  Widget _buildNotificationOption(
      String title, bool switchValue, Function(bool) onChanged) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      trailing: Switch(
        value: switchValue,
        onChanged: onChanged,
      ),
    );
  }
}
