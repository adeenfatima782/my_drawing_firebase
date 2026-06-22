import 'package:flutter/material.dart';

class AppSettingsScreen extends StatefulWidget {
  @override
  _AppSettingsScreenState createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool darkMode = false;
  bool autoSave = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(title: Text("Dark Mode"), value: darkMode, onChanged: (v) => setState(() => darkMode = v)),
          SwitchListTile(title: Text("Auto Save Drawing"), value: autoSave, onChanged: (v) => setState(() => autoSave = v)),
          ListTile(title: Text("Canvas Size"), subtitle: Text("Default: 1080x1080"), trailing: Icon(Icons.arrow_forward_ios)),
        ],
      ),
    );
  }
}
