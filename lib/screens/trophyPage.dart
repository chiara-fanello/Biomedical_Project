import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/trophyIcon.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrophyPage extends StatelessWidget {
  final List<Trophy> trophies = [
    Trophy(name: "Primo giro in bici", icon: "bicycle-solid.svg", progress: 1),
    Trophy(
      name: "10.000 passi",
      icon: "person-walking-solid.svg",
      progress: 12,
    ),
    Trophy(
      name: "Visitatore culturale",
      icon: "landmark-dome-solid.svg",
      progress: 4,
    ),
    Trophy(
      name: "Camminatore urbano",
      icon: "person-walking-solid.svg",
      progress: 9,
    ),
    Trophy(name: "Green Hero", icon: "leaf-solid.svg", progress: 30),
    Trophy(name: "Esploratore locale", icon: "tree-solid.svg", progress: 55),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Achievements"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: trophies.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Più spazio per ogni trofeo
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 0.9, // Migliora proporzioni verticali
          ),
          itemBuilder: (context, index) {
            final trophy = trophies[index];
            return TrophyIcon(trophy: trophy);
          },
        ),
      ),
    );
  }
}

enum TrophyLevel { wood, bronze, silver, gold }

class Trophy {
  final String name;
  final String icon;
  final int progress;
  final TrophyLevel level;

  Trophy({required this.name, required this.icon, required this.progress})
    : level = _getLevelFromProgress(progress);

  static TrophyLevel _getLevelFromProgress(int progress) {
    return (progress >= 50)
        ? TrophyLevel.gold
        : (progress >= 10)
        ? TrophyLevel.silver
        : (progress >= 5)
        ? TrophyLevel.bronze
        : TrophyLevel.wood;
  }
}
