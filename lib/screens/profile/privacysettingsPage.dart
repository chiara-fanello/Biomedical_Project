import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatefulWidget {
  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool isPrivate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy')),
      body: SwitchListTile(
        title: Text('Profilo privato'),
        subtitle: Text('Solo gli amici possono vedere le tue attività'),
        value: isPrivate,
        onChanged: (value) {
          setState(() {
            isPrivate = value;
          });
        },
      ),
    );
  }
}
