import 'package:car_black_box/models/car.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import '../favourite_palces/place.dart';

class MapPage extends StatefulWidget {
  const MapPage(this.car, {super.key});

  @override
  State<MapPage> createState() => _MapPageState();

  final Car car;
}

class _MapPageState extends State<MapPage> {
  LatLng center = LatLng(31.205753, 29.924526);
  LatLng favoriteAnchor = LatLng(31.205753, 29.924526);
  bool favoriteAnchorEnabled = false;

  @override
  void initState() {
    super.initState();
    center = LatLng(widget.car.lat ?? 31.205753, widget.car.lng ?? 29.924526);
  }

  void _addPlace(lat, lng) async {
    final place = Place(name: 'point', latitude: lat, longitude: lng);
    final box = Hive.box<Place>('favoritePlaces');
    await box.add(place);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Place added successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: Hive.box<Place>('favoritePlaces').listenable(),
            builder: (context, Box<Place> box, _) {
              return FlutterMap(
                options: MapOptions(
                    zoom: 10,
                    center: center,
                    onTap: (context2, point) {
                      setState(() {
                        favoriteAnchorEnabled = false;
                      });
                    },
                    onLongPress: (context2, point) {
                      setState(() {
                        favoriteAnchorEnabled = true;
                        favoriteAnchor = point;
                      });
                    }),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  Builder(builder: (context) {
                    if (favoriteAnchorEnabled) {
                      return MarkerLayer(
                        markers: [
                          Marker(
                            point: favoriteAnchor ,
                            width: 20,
                            height: 20,
                            builder: (BuildContext context) {
                              return const Icon(Icons.location_on, color: Colors.blue, size: 40,);
                            },
                          ),
                        ],
                      );
                    }
                    return Container();
                  }),
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
                  ...box.values.map((place) {
                    return  MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(place.latitude, place.longitude),
                          builder: (BuildContext context) {
                            return const Icon(Icons.favorite_outlined, color: Colors.red, size: 30,);
                          },
                        ),
                      ],
                    );
                  }).toList()
                 ,
                  // box.values.map((place) {
                  //   return Marker(
                  //     point: center,
                  //     width: 50.0,
                  //     height: 50.0,
                  //     // child: Image.asset('assets/mapcar.png'),
                  //     builder: (BuildContext context) {
                  //       return Image.asset('assets/mapcar.png');
                  //     },
                  //   );
                  // }).toList()

                ],
              );
            }
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Card(
                key: const ValueKey('ss'),
                color: Colors.black.withOpacity(0.65),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Car Live location .. '),
                ),)
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              child: Builder(
                key: ValueKey(favoriteAnchorEnabled),
                builder: (context) {
                  if( favoriteAnchorEnabled ) {
                    return ElevatedButton.icon(onPressed: (){
                      _addPlace(favoriteAnchor.latitude, favoriteAnchor.longitude);

                      setState(() {
                      favoriteAnchorEnabled = false;
                      });
                    },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red
                        ),
                        icon: const Icon(Icons.favorite_outlined, color: Colors.white,),
                        label: const Text('Add favorite location'));
                  }
                  return Card(
                    key: const ValueKey('ss'),
                    color: Colors.black.withOpacity(0.65),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Long press to add favorite location'),
                    ),);

                }
              ),
            ),
          ),
        ],
      )
    );
  }
}
