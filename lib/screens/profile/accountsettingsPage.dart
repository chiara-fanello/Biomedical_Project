import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String name = '';
    String email = '';
    String password = '';

    return Scaffold(
      appBar: AppBar(title: Text('Impostazioni Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome completo'),
                onSaved: (value) => name = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => email = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) => password = value ?? '',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState?.save();
                  // Salva i dati (da implementare)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Informazioni aggiornate')),
                  );
                },
                child: Text('Salva modifiche'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
