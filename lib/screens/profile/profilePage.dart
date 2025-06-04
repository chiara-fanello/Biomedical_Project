import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/goalsProvider.dart';
import '../loginPage.dart';
import '../../provider/loginProvider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  Map<String, dynamic> getStatusData(int index) {
    if (index <= 1) {
      return {
        'status': 'Seed of Strength',
        'title':
            'Everything you need is already inside you. The first step is the bravest. ',
        'subtitle':
            'You\'ve started. Every action is a promise to your future.',
        'icon': Icons.eco,
      };
    } else if (index <= 3) {
      return {
        'status': 'Sprout of Willpower',
        'title':
            'Even the hardest rock yields to persistence. You\'re already breaking through.',
        'subtitle': 'You\'re rising from the ground. There\'s light ahead.',
        'icon': Icons.spa,
      };
    } else if (index <= 7) {
      return {
        'status': 'Plant of Consistency',
        'title':
            'You\'re putting down roots. Your strength is no longer just a thought—it\’s real',
        'subtitle': 'You\'re building yourself, day by day.',
        'icon': Icons.grass,
      };
    } else if (index <= 13) {
      return {
        'status': 'Sapling of Resilience',
        'title':
            'You’ve weathered your first storms. You’re stronger. You’re steadier.',
        'subtitle': 'Those who stop fall back. You chose to rise.',
        'icon': Icons.nature_people,
      };
    } else if (index <= 17) {
      return {
        'status': 'Tree of Strength',
        'title': 'You can’t be ignored now. Your presence has power.',
        'subtitle': 'Your body, mind, and energy are rising together.',
        'icon': Icons.park,
      };
    } else {
      return {
        'status': 'Legendary Oak',
        'title':
            'You haven’t just grown. You’ve transformed. You’ve become a guide.',
        'subtitle':
            'Your consistency brought you beyond your limits. You are your greatest achievement.',
        'icon': Icons.star,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final int activeLesson =
        Provider.of<GoalsProvider>(
          context,
        ).lessons(); 
    final statusData = getStatusData(activeLesson);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .stretch, 
            children: [
              _buildProfileHeader(),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(statusData['icon'], size: 24),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                statusData['status'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                statusData['title'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                statusData['subtitle'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '$activeLesson lessons completed. You\'re growing stronger!',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              _buildSettingsOption(
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Esci dal tuo account',
                onTap: () async {
                  await Provider.of<LoginProvider>(
                    context,
                    listen: false,
                  ).logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
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
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
          const SizedBox(height: 12),
          Text(
            'Debuggers Anonimi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'debuggersanonimi@email.com',
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
