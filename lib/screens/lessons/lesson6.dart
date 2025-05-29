import 'package:flutter/material.dart';

class Lesson6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson6')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Importance of Renewable Energies',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Renewable energies are a fundamental solution to reduce pollution and fight climate change. Sources like the sun, wind, water, and biomass are inexhaustible and environmentally friendly. Using solar panels, wind turbines, and hydroelectric plants allows us to produce energy without emitting greenhouse gases. Transitioning to renewable energies is not only an eco-friendly choice but also economically beneficial: in the long run, it can lower energy costs and create new jobs. Many countries are investing in these technologies to achieve energy independence and meet international commitments against global warming. Each of us can contribute by choosing clean energy providers or installing solar panels at home. Promoting renewable energies means protecting our planet and ensuring a more sustainable future for everyone.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
