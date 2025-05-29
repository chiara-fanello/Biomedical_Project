import 'package:flutter/material.dart';

class Lesson8 extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson8')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Social Enterprise and Circular Economy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Social enterprises represent an innovative way of doing business, focusing on community well-being and environmental protection alongside profit. These enterprises develop projects that generate social benefits, such as integrating disadvantaged people into the workforce or promoting eco-friendly practices. The circular economy aims to reduce waste and maximize resource reuse through recycling, reusing, and sustainable design. Promoting these practices means creating a more efficient and planet-friendly economic system. Businesses and consumers play a vital role in this process: by choosing sustainable products, reducing waste, and supporting responsible companies. Together, we can build an economy that values people and the planet for a fairer, more sustainable future.',
               style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
