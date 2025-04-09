import 'package:flutter/material.dart';
import 'login.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Hero(
            tag: 'logo',
            child: Image.asset(
              'assets/logo.png',
              height: 300,
              color: Colors.deepPurple.shade400,
            ),
          ),
        ),
        const Column(
          children: [
            Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            Hero(
              tag: 'text',
              child: Text(
                'Keeper',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Hero(
          tag: 'button',
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const LoginScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Get Started'),
              )),
        )
      ]),
    ));
  }
}
