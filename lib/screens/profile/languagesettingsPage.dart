import 'package:flutter/material.dart';

class LanguageSettingsPage extends StatelessWidget {
  final List<String> languages = ['Italiano', 'English', 'Español'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Language')),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(languages[index]),
            onTap: () {
              // Imposta lingua
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Now your language is ${languages[index]}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
