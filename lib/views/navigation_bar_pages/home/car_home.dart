import 'package:flutter/material.dart';
import '../../../controller/appCubit/app_cubit.dart';
import '../../../models/car.dart';
import '../../../services/get_it.dart';
import '../../car_screens/car_information/car_information_screen.dart';
import '../../car_screens/dash_cam_screen/dash_cam_screen.dart';
import '../../car_screens/emergency/emergency_screen.dart';
import '../../car_screens/health_card/health_Card_screen.dart';
import '../../car_screens/maintanance/maintainance_screen.dart';
import '../../car_screens/trip_details/trip_list_page.dart';
import '../../home/weather_card.dart';

class CarHome extends StatefulWidget {
  CarHome(this.car, {super.key});

  final Car car;

  @override
  State<CarHome> createState() => _CarHomeState();
}

class _CarHomeState extends State<CarHome> {
  final appCubit = getIt<AppCubit>();

  @override
  Widget build(BuildContext context) {
    final double? lat = widget.car.lat ;
    final double? lng = widget.car.lng ;

    return Column(
      children: [
         WeatherCard(lat: lat??0, lon: lng??0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1.5),
              children: [
                pageCard(TripListPage(), 'Trip Details', Icons.map_outlined),
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
        color: const Color(0xFF7c55d4).withOpacity(0.1),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Color(0xffaa8fe8), Color(0xff6340b2)], // Gradient colors
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
