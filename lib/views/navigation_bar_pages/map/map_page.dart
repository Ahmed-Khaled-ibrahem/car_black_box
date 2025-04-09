import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  LatLng center =  LatLng(31.205753, 29.924526);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
          // initialZoom: 15.0,
          // initialCenter: center,
          onLongPress: (context2, point) {}),

      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          // attributionBuilder: (_) {
        ),

         MarkerLayer(
          markers: [
            Marker(
              point: center,
              width: 50.0,
              height: 50.0,
              // child: Image.asset('assets/mapcar.png'),
              builder: (BuildContext context) {
                return Image.asset('assets/mapcar.png');
              },
            ),
          ],
        ),
        // PolylineLayer(
        //   polylines: [
        //     Polyline(
        //       points: context.read<AppBloc>().polyPoints,
        //       color: Colors.blue,
        //       strokeWidth: 4.0,
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
