import 'package:flutter/material.dart';

class LanguageSettingsPage extends StatelessWidget {
  final List<String> languages = ['Italiano', 'Inglese', 'Spagnolo'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lingua')),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(languages[index]),
            onTap: () {
              // Imposta lingua
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lingua impostata su ${languages[index]}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
