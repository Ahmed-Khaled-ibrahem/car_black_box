import 'package:car_black_box/services/get_it.dart';
import 'package:car_black_box/services/shared_preferences_service.dart';
import 'package:car_black_box/services/theme_service.dart';
import 'package:car_black_box/views/car_screens/car_information/car.dart';
import 'package:car_black_box/views/car_screens/emergency/emergency_contact.dart';
import 'package:car_black_box/views/car_screens/health_card/car_health.dart';
import 'package:car_black_box/views/car_screens/maintanance/car_maintenance.dart';
import 'package:car_black_box/views/car_screens/trip_details/trip_model.dart';
import 'package:car_black_box/views/navigation_bar_pages/favourite_palces/place.dart';
import 'package:car_black_box/views/profile/user_profile.dart';
import 'package:car_black_box/views/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'const/loading.dart';
import 'controller/appCubit/app_cubit.dart';
import 'controller/theme_bloc/theme_bloc.dart';
import 'controller/theme_bloc/theme_state.dart';
import 'const/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserProfileAdapter());
  await Hive.openBox<UserProfile>('profileBox');
  Hive.registerAdapter(CarAdapter());
  await Hive.openBox<Car>('cars');
  Hive.registerAdapter(CarHealthAdapter());
  await Hive.openBox<CarHealth>('car_health');
  Hive.registerAdapter(CarMaintenanceAdapter());
  await Hive.openBox<CarMaintenance>('car_maintenance');
  Hive.registerAdapter(EmergencyContactAdapter());
  await Hive.openBox<EmergencyContact>('emergency_contacts');
  Hive.registerAdapter(TripModelAdapter());
  await Hive.openBox<TripModel>('trips');
  Hive.registerAdapter(PlaceAdapter());
  await Hive.openBox<Place>('favoritePlaces');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesService.instance.init();
  getItSetup();
  ThemeService.getTheme();
  easyLoadingSetup();
  runApp(BlocProvider(
    create: (context) => getIt<AppCubit>(),
    child: BlocProvider(
      create: (context) => getIt<ThemeBloc>(),
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    ThemeService.initialize(context);
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    ThemeService.autoChangeTheme(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Keeper',
          debugShowCheckedModeBanner: false,
          theme: ThemeService.buildTheme(state),
          home: const SplashScreen(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
