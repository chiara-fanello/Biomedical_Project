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
        title: Text('Private profile'),
        subtitle: Text('Only friends can see your activities'),
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
