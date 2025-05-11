import 'package:flutter/widgets.dart';

class Objective {
  String title;
  bool completed;
  Objective(this.title, {this.completed= false});
}

class ObiettiviProvider with ChangeNotifier {
  List<Objective> _objectives = [
    Objective('Take 8000 steps'),
    Objective('Rent a bike'),
    Objective("Stand 5 minutes per hour for 5 hours"),
  ];

  List<Objective> get objectives => _objectives;

  void toggleCompleted(int index) {
    _objectives[index].completed != _objectives[index].completed;
    notifyListeners();
  }
}
