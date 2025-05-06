import 'package:flutter/material.dart';

class NotificationsSettingsPage extends StatefulWidget {
  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool emailNotif = true;
  bool pushNotif = false;
  String selectedAlertType = 'Banner';
  String selectedSound = 'Tri-tone';

  final List<String> alertTypes = [
    'Banner',
    'Centro Notifiche',
    'Blocco Schermo',
  ];
  final List<String> notificationSounds = [
    'Tri-tone',
    'Chime',
    'Glass',
    'Horn',
    'Bell',
    'Electronic',
    'Synth',
    'Drip',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifiche')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Notifiche via email'),
            value: emailNotif,
            onChanged: (val) => setState(() => emailNotif = val),
          ),
          SwitchListTile(
            title: Text('Notifiche push'),
            value: pushNotif,
            onChanged: (val) => setState(() => pushNotif = val),
          ),
          Divider(),
          ListTile(
            title: Text('Tipologia Avviso'),
            subtitle: Text(selectedAlertType),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: () => _selectAlertType(context),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              'Suono Notifica',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ...notificationSounds.map((sound) {
            return RadioListTile<String>(
              title: Text(sound),
              value: sound,
              groupValue: selectedSound,
              onChanged: (value) {
                setState(() {
                  selectedSound = value!;
                });
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  void _selectAlertType(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children:
              alertTypes.map((type) {
                return ListTile(
                  title: Text(type),
                  onTap: () {
                    setState(() {
                      selectedAlertType = type;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
        );
      },
    );
  }
}
