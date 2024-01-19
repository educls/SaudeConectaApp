

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
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
        title: const Text(
        "Configurações",
        style: TextStyle(
          fontSize: 20
          ),
        ),
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
        ],
      ),
    );
  }
}