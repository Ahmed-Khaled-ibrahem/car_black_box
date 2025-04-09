import 'package:car_black_box/services/get_it.dart';
import 'package:flutter/material.dart';
import '../../services/firebase_auth.dart';

class MyAppBar extends AppBar {
  MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  var userName = getIt<FirebaseAuthRepo>().currentUser;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFa587e9),
      foregroundColor: Colors.white,
      // title:  Text('Good morning keeper, ${userName?.displayName}', style: const TextStyle(fontSize: 16),),
      title:  const Text('Good morning Keeper', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),),
    );
  }
}



