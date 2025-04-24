import 'dart:io';
import 'package:car_black_box/controller/appCubit/app_cubit.dart';
import 'package:car_black_box/controller/theme_bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../controller/theme_bloc/theme_bloc.dart';
import '../../services/firebase_auth.dart';
import '../../services/get_it.dart';
import '../device_configeration/device_configuration_screen.dart';
import '../profile/user_profile.dart';
import '../profile/profile_screen.dart';
import 'app_bar.dart';
import 'car_card.dart';
import 'my_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  void initState() {
    super.initState();
    getIt<AppCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return Scaffold(
                  backgroundColor: const Color(0xFFa587e9),
                  drawer: const MyDrawer(),
                  appBar: MyAppBar(),
                  body: Stack(children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: profileWidget(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: const Card(
                          margin: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Expanded(child: CarSpeedCard()),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 3.5,
                        child: Card(
                          color: state.isDark
                              ? const Color(0xFF323031)
                              : Colors.white,
                          margin: const EdgeInsets.all(0),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50)),
                          ),
                          child: addDevice(context),
                        ),
                      ),
                    )
                  ]));
            },
          ),
        );
      },
    );
  }

  Widget profileWidget() {
    var userName = getIt<FirebaseAuthRepo>().currentUser;
    final profileBox = Hive.box<UserProfile>('profileBox');
    String displayedName = '';

    final profile = profileBox.get('profile');
    String? imagePath;

    if (profile != null) {
      displayedName = profile.name ;
      imagePath = profile.imagePath;
    }

    if(displayedName == ''){
      displayedName = userName?.displayName ?? '';
    }

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: imagePath != null && imagePath.isNotEmpty
                ? FileImage(File(imagePath))
                : const AssetImage('assets/default_profile.png')
            as ImageProvider,
            child: imagePath == null
                ? const Icon(Icons.camera_alt,
                size: 20, color: Colors.white)
                : null,
          ),
          // contentPadding: const EdgeInsets.all(10),
          horizontalTitleGap: 10,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()));
          },
          title: Text(
            displayedName,
            style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          subtitle:  Text(
            '${userName?.email}',
            style: const TextStyle(
                color: Colors.indigo,
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget addDevice(context) {
    return Card(
      margin: const EdgeInsets.all(20),
      color: Colors.lightGreenAccent.withOpacity(0),
      borderOnForeground: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        // side: BorderSide(color: Colors.black)
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DeviceConfigurationScreen()));
          },
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Add Device',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFa587e9)),
                ),
                Icon(
                  Icons.add_box_rounded,
                  color: Color(0xFFa587e9),
                  size: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
