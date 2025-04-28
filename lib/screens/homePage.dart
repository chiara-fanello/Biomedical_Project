import 'package:flutter/material.dart';
import 'package:projectapp/mode/obiettivi.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Benvenuto!')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'I tuoi progressi di oggi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRing(
                    context,
                    percent: 0.7,
                    color: Colors.deepPurple,
                    label: "Movimento",
                  ),
                  _buildRing(
                    context,
                    percent: 0.5,
                    color: Colors.blueAccent,
                    label: "Allenamento",
                  ),
                  _buildRing(
                    context,
                    percent: 0.3,
                    color: Colors.green,
                    label: "Pausa",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'I tuoi obiettivi di oggi:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: Consumer<ObiettiviProvider>(
                    builder: (context, provider, child) {
                      if (provider.obiettivi.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              'Nessun obiettivo per oggi!',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: provider.obiettivi.length,
                        separatorBuilder:
                            (context, index) => Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                              height: 1,
                            ),
                        itemBuilder: (context, index) {
                          final obiettivo = provider.obiettivi[index];
                          return CheckboxListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              obiettivo.titolo,
                              style: TextStyle(
                                fontSize: 18,
                                decoration:
                                    obiettivo.completato
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                color:
                                    obiettivo.completato
                                        ? Colors.grey
                                        : Colors.black,
                              ),
                            ),
                            value: obiettivo.completato,
                            onChanged: (value) {
                              provider.toggleCompleted(index);
                            },
                            activeColor: Colors.deepPurple,
                            checkColor: Colors.white,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      size: 40,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Completa i tuoi obiettivi!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Raggiungi i tuoi traguardi per ottenere coupon esclusivi per musei e teatri!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurple[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRing(
    BuildContext context, {
    required double percent,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 45.0,
          lineWidth: 8.0,
          percent: percent,
          center: Text(
            "${(percent * 100).toInt()}%",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          progressColor: color,
          backgroundColor: Colors.grey.shade300,
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animateFromLastPercent: true,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
