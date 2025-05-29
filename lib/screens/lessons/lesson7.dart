import 'package:flutter/material.dart';

class Lesson7 extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson7')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Importance of Biodiversity',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Biodiversity refers to the variety of living forms on Earth, including plants, animals, and microorganisms. This natural richness is essential for maintaining ecosystems’ balance and human well-being. The loss of biodiversity, caused by deforestation, pollution, and climate change, threatens our very survival. Protecting endangered species and conserving natural habitats are crucial actions to maintain planetary health. Biodiversity provides food resources, medicines, and materials, and contributes to climate stability. Everyone can do their part by avoiding the purchase of illegal or deforestation-related products and supporting conservation projects. Protecting biodiversity is a shared responsibility: only by doing so can we ensure a world full of life and balance for future generations.',
               style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
