import 'package:flutter/widgets.dart';

class Obiettivo {
  String titolo;
  bool completato;
  Obiettivo(this.titolo, {this.completato = false});
}

class ObiettiviProvider with ChangeNotifier {
  List<Obiettivo> _obiettivi = [
    Obiettivo('Fare 8000 passi'),
    Obiettivo('Noleggiare una bici'),
    Obiettivo("Stare 5 minuti in piedi all'ora per 5 ore"),
  ];

  List<Obiettivo> get obiettivi => _obiettivi;

  void toggleCompleted(int index) {
    _obiettivi[index].completato != _obiettivi[index].completato;
    notifyListeners();
  }
}
