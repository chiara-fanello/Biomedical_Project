import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/rhrDataProvider.dart'; // Assicurati che il path sia corretto
import 'package:fl_chart/fl_chart.dart';

class RestingHeartRatePage extends StatefulWidget {
  final String day;

  const RestingHeartRatePage({Key? key, required this.day}) : super(key: key);

  @override
  _RestingHeartRatePageState createState() => _RestingHeartRatePageState();
}

class _RestingHeartRatePageState extends State<RestingHeartRatePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<RestingHeartRateProvider>(
      context,
      listen: false,
    );
    await provider.fetchRestingHeartRate(widget.day);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RestingHeartRateProvider>(context);
    final rhr = provider.restingHeartRate;

    return Scaffold(
      appBar: AppBar(title: Text('Resting Heart Rate')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : rhr == null
              ? Center(child: Text('Nessun dato disponibile.'))
              : Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LineChart(
                        LineChartData(
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final int index = value.toInt();
                                  if (index < 0 || index >= rhr.data.length)
                                    return Container();
                                  final time = rhr.data[index].time;
                                  return Text(
                                    time.substring(0, 5),
                                    style: TextStyle(fontSize: 10),
                                  );
                                },
                                interval: 1,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 10,
                              ),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                for (int i = 0; i < rhr.data.length; i++)
                                  FlSpot(i.toDouble(), rhr.data[i].value),
                              ],
                              isCurved: false,
                              dotData: FlDotData(show: true),
                              barWidth: 2,
                              color: Colors.red,
                            ),
                          ],
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: true),
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: rhr.data.length,
                      itemBuilder: (context, index) {
                        final entry = rhr.data[index];
                        return ListTile(
                          leading: Icon(Icons.favorite, color: Colors.red),
                          title: Text('${entry.value.toStringAsFixed(1)} bpm'),
                          subtitle: Text(
                            'Ora: ${entry.time} | Errore: ±${entry.error}',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
