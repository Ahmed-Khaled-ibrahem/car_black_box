import 'package:flutter/material.dart';
import '../../services/firebase_auth.dart';
import '../../services/get_it.dart';
import '../home/home.dart';
import '../login/getStarted.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getIt<FirebaseAuthRepo>().user, builder: (context, snapshot) {
          if(snapshot.hasData){
            return const Home();
          }
          return const GetStarted();
        },);
  }
}
