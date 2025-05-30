import 'package:intl/intl.dart';

class CaloriesData{
  final DateTime time;
  final int value;

  CaloriesData({required this.time, required this.value});

  CaloriesData.fromJson(String date, Map<String, dynamic> json) :
      time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
      value = int.parse(json["value"]);

  @override
  String toString() {
    return 'CaloriesData(time: $time, value: $value)';
  }//toString

  
}//Calories