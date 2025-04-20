
import 'package:car_black_box/controller/appCubit/app_cubit.dart';
import 'package:car_black_box/services/firebase_real_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../../const/car_colors.dart';
import '../../models/car.dart';
import '../../services/firebase_auth.dart';
import '../../services/get_it.dart';
import '../car/car_screen.dart';
import '../common/confirmation_dialog.dart';

class CarSpeedCard extends StatefulWidget {
  const CarSpeedCard({super.key});

  @override
  _CarSpeedCardState createState() => _CarSpeedCardState();
}

class _CarSpeedCardState extends State<CarSpeedCard> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        var allCars = getIt<AppCubit>().cars;
        String myID = getIt<FirebaseAuthRepo>().currentUser!.uid.toString();

        var myCars = allCars.where((element) {
          return element.owners?.contains(myID) ?? false;
        }).toList();


        if(myCars.isEmpty){
          return embtyCard();
        }

        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 300 ),
          children: myCars.map((e) => carCard(e)).toList(),
        );
      },
    );
  }

  Widget carCard(Car c) {
    return Card(
      color: Colors.green.withOpacity(0.8),
      elevation: 30,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CarScreen(c)));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              margin: const EdgeInsets.all(0),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text(c.name ?? '----', style: const TextStyle(color: Colors.white,)),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        ConfirmationDialog(
                                          title: 'Delete',
                                          onConfirm: () {
                                            getIt<FirebaseRealTimeDB>().deleteCar(c.id ?? '');
                                          },
                                          message:
                                          'Are you sure you want to delete this car?',
                                        ),
                                  );
                                },
                                icon: const Icon(MaterialCommunityIcons.delete,
                                  color: Colors.amberAccent,),
                              )
                            ]),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${c.speed} km/h",
                              style: const TextStyle(
                                  fontSize: 32,color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on,
                                size: 30, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'جدة',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500,color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 30,
                    bottom: 0,
                    child: Transform.scale(
                        scale: 2.5,
                        child: Image.asset(carColors[c.image ?? 0] ,
                            height: 70, width: 70)),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
              onTap: () {
                MapsLauncher.launchCoordinates(
                    c.lat??0,
                    c.lng??0,);
              },
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 40,
                width: double.infinity,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send_rounded, size: 30),
                    Text(
                      'Navigate',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget embtyCard() {
    return const Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Icon(Icons.notes_rounded, size: 100),
          Text('Once you add a car', style: TextStyle(fontSize: 20),),
          Text('It will appear here', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
        ],
      ),
    );
  }
}
