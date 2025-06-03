import 'package:flutter/material.dart';

class GoalsProvider with ChangeNotifier {
  int active_lesson = 0;

  int lessons() {
    return active_lesson;
  }

  void setLessonsPassed() {
    active_lesson += 1;
    notifyListeners();
  }

  String getGoalString(int id) {
    switch (id) {
      case 1:
        return 'Walk at least 6,000 steps per 3 consecutive days';
      case 2:
        return 'Go to bed before 11 PM and sleep at least 6 hours for 3 nights';
      case 3:
        return 'Burn at least 2,000 kcal in total through movement in one week';
      case 4:
        return 'Reduce night awakenings and improve sleep quality for 3 consecutive nights';
      case 5:
        return 'Reach a total of 50,000 steps in 7 days';
      case 6:
        return 'Cover at least 5 km in 3 days';
      case 7:
        return 'Walk or run at least 2 km every day for 4 days';
      case 8:
        return 'Burn at least 300 kcal through movement each day for 5 days';
      case 9:
        return 'Cover at least 20 km total over a week';
      case 10:
        return 'Lower your average resting heart rate compared to the previous week';
      case 11:
        return 'Maintain “low” or “normal” stress levels for at least 5 out of 7 days';
      case 12:
        return 'Burn more than 500 kcal in one day through physical activity';
      case 13:
        return 'Exceed 10,000 steps for 2 days this week';
      case 14:
        return 'Walk at least 2 days in a row without dropping below 8,000 steps';
      case 15:
        return 'Take a single walk of at least 4 km in one day';
      case 16:
        return 'Do a high-intensity activity that burns at least 200 kcal in under 30 minutes';
      case 17:
        return 'Sleep at least 7 hours for 3 nights in a row';
      case 18:
        return 'Maintain an average of at least 6.5 hours of sleep for 5 days';
      case 19:
        return 'Improve your weekly resting heart rate by at least 2 bpm';
      case 20:
        return 'Reduce night awakenings and improve sleep quality for 5 consecutive nights';
      default:
        return 'Error';
    }
  }
}