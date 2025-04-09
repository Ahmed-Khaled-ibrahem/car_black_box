import 'package:car_black_box/views/car_screens/trip_details/trip_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'trip_model.dart';

class TripListPage extends StatefulWidget {
  @override
  _TripListPageState createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  late Box<TripModel> _tripBox;

  @override
  void initState() {
    super.initState();
    _tripBox = Hive.box<TripModel>('trips');
  }

  void _deleteTrip(int index) {
    _tripBox.deleteAt(index);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Trip deleted successfully!")),
    );
  }

  void _navigateToAddTrip() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripDetailsPage()),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trips List")),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/map_loc.json',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _tripBox.isEmpty
                  ? const Text("No trips available. Add a new trip!")
                  : ListView.builder(
                itemCount: _tripBox.length,
                itemBuilder: (context, index) {
                  final trip = _tripBox.getAt(index);
                  return Card(
                    color: Colors.grey.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.blue,width:1)
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    // elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(trip!.dateOfTrip,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(trip.tripName, style: const TextStyle(fontWeight: FontWeight.bold),),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () => _deleteTrip(index),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Column(children: [
                                Icon(Icons.circle,
                                    size: 20, color: Colors.green),
                                Text('|'),
                                Text('|'),
                                Text('|'),
                                Icon(Icons.circle,
                                    size: 20, color: Colors.redAccent),
                              ]),
                              const SizedBox(width: 10,),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(trip.startLocation, style: const TextStyle(fontWeight: FontWeight.bold),),
                                    Text(trip.startTime),
                                    const SizedBox(height: 20,),
                                    Text(trip.endLocation, style: const TextStyle(fontWeight: FontWeight.bold),),
                                    Text(trip.endTime),
                                  ]
                              ),
                            ],
                          ),

                          const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 12),
                                ),
                              ])
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTrip,
        child: const Icon(Icons.add),
      ),
    );
  }
}
