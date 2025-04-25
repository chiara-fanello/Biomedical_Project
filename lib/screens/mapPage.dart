import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intorno a te...'),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(45.406435, 11.876761), // Milano
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                child: Icon(
                  Icons.location_on, color: Colors.red, size: 40,),
                width: 80.0,
                height: 80.0,
                point: LatLng(45.406435, 11.876761),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
