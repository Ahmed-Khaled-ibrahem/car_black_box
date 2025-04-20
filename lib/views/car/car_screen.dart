import 'package:car_black_box/views/home/my_drawer.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../models/car.dart';
import '../navigation_bar_pages/favourite_palces/favourite_palces_screen.dart';
import '../navigation_bar_pages/home/car_home.dart';
import '../navigation_bar_pages/map/map_page.dart';
import '../navigation_bar_pages/record/record_page.dart';

class CarScreen extends StatefulWidget {
  CarScreen(this.car, {super.key});
  Car car;
  @override
  State<CarScreen> createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
   int selectedTab = 0;
   List tabs = [];
   @override
  void initState() {
    super.initState();
    tabs = [ CarHome(widget.car), const MapPage(), const RecordPage(), const FavouritePalcesScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car.name ?? '----'),
        actions: [TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Back'))],
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar:  SizedBox(
        height: 100,
        child: DotNavigationBar(
          currentIndex: selectedTab,
          marginR: const EdgeInsets.all(0),
          paddingR: const EdgeInsets.all(5),
          itemPadding: const EdgeInsets.all(20),
          onTap: _handleIndexChanged,
          backgroundColor: const Color(0xFF7c55d4),
          enableFloatingNavBar: true,
          selectedItemColor: Colors.white,
          // dotIndicatorColor: Colors.black.withOpacity(1),
          items: [
            DotNavigationBarItem(
              icon: const Icon(Icons.home),
              selectedColor: Colors.amber,
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.map),
              selectedColor: Colors.amber,
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.fiber_manual_record),
              selectedColor: Colors.amber,
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.favorite_border),
              selectedColor: Colors.amber,
            ),

          ],
        ),
      ),
      body: tabs[selectedTab],
    );
  }

  _handleIndexChanged(int index) {
    setState(() {
      selectedTab = index;
    });
  }
}
