import 'package:flutter/material.dart';
import '../../car_screens/car_information/car_information_screen.dart';
import '../../car_screens/dash_cam_screen/dash_cam_screen.dart';
import '../../car_screens/emergency/emergency_screen.dart';
import '../../car_screens/health_card/health_Card_screen.dart';
import '../../car_screens/maintanance/maintainance_screen.dart';
import '../../car_screens/trip_details/trip_list_page.dart';
import '../../home/weather_card.dart';

class CarHome extends StatefulWidget {
  const CarHome({super.key});

  @override
  State<CarHome> createState() => _CarHomeState();
}

class _CarHomeState extends State<CarHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WeatherCard(lat: 30.0444, lon: 31.2357),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1.5),
              children: [
                pageCard(TripListPage(), 'Trip Details',
                    Icons.map_outlined),
                pageCard(const DashCamScreen(), 'Dash Cam',
                    Icons.camera_alt_outlined),
                pageCard(CarInfoPage(), 'Car Information', Icons.info_outline),
                pageCard(CarHealthPage(), 'Health Card',
                    Icons.health_and_safety_outlined),
                pageCard(const EmergencyCallPage(), 'Emergency',
                    Icons.emergency_outlined),
                pageCard(
                    CarMaintenancePage(), 'Maintenance', Icons.build_outlined),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget pageCard(Widget page, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        color: const Color(0xFF7c55d4),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient:  LinearGradient(
              colors: [ const Color(0xFF7c55d4),  const Color(0xFF7c55d4).withGreen(130)], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            color: Colors.red,
          ),

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                ),
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
