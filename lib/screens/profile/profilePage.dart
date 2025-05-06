import 'package:flutter/material.dart';
import 'accountsettingsPage.dart';
import 'privacysettingsPage.dart';
import 'notificationsettingsPage.dart';
import 'languagesettingsPage.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Profilo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildSettingsOption(
            icon: Icons.person,
            title: 'Account',
            subtitle: 'Modifica informazioni personali',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AccountSettingsPage()),
              );
            },
          ),
          _buildSettingsOption(
            icon: Icons.lock,
            title: 'Privacy',
            subtitle: 'Gestisci la privacy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PrivacySettingsPage()),
              );
            },
          ),
          _buildSettingsOption(
            icon: Icons.notifications,
            title: 'Notifiche',
            subtitle: 'Preferenze notifiche',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationsSettingsPage()),
              );
            },
          ),
          _buildSettingsOption(
            icon: Icons.language,
            title: 'Lingua',
            subtitle: 'Cambia lingua',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LanguageSettingsPage()),
              );
            },
          ),
          _buildSettingsOption(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Esci dall\'account',
            onTap: () {
              // logout logic
              Navigator.of(context).popUntil(
                (route) => route.isFirst,
              ); // semplice ritorno alla LoginPage
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/avatar.jpg'),
          ),
          const SizedBox(height: 12),
          Text(
            'Mario Rossi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'mario.rossi@email.com',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
