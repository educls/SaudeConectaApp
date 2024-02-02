

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../utils/class/Theme.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool _switchTheme = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          )
        ),
        title: const Text(
        "Configurações",
        style: TextStyle(
          fontSize: 20
          ),
        ),
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
                                      ? const Color.fromARGB(255, 35, 35, 36)
                                      : const Color.fromARGB(255, 54, 158, 255),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Tema"),
            value: _switchTheme,
            onChanged: (bool value) {
              setState(() {
                _switchTheme = value;
              });
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          ElevatedButton.icon(
            onPressed: () {
              NotificationService.showNotification(title: 'titulo', body: 'body', payload: 'payload');
            }, 
            icon: const Icon(Icons.notification_add_outlined), 
            label: const Text("notificação")
          ),
        ],
      ),
    );
  }
}