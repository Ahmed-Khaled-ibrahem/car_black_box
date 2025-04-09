
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controller/theme_bloc/theme_bloc.dart';
import '../../controller/theme_bloc/theme_event.dart';
import '../../controller/theme_bloc/theme_state.dart';
import '../support/send_support_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Column(
            children: [
              SingleChildScrollView(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    'Need help?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SendSupportPage()));
                      },
                      child: const Text(
                        'Send Support',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                      )),
                ]),
              ),
            ],
          ),
        ),
        body: SafeArea(
            child: Center(
          child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 250,
                    color: Colors.deepPurple,
                  ),
                ),
                // const Text(
                //   'Keeper',
                //   style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                // ),
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    return ElevatedButton.icon(
                      icon: state.isDark
                          ? const Icon(Icons.dark_mode)
                          : const Icon(Icons.light_mode),
                      onPressed: () {
                        state.isDark ? lightTheme(context) : darkTheme(context);
                      },
                      label: state.isDark
                          ? const Text('Dark')
                          : const Text('Light'),
                    );
                  },
                ),
              ]),
        )),
      ),
    );
  }

  void deviceTheme(context) {
    Brightness brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    BlocProvider.of<ThemeBloc>(context).add(ChangeTheme(
        useDeviceTheme: true, isDark: brightness == Brightness.dark));
    // getIt<NavigationService>().goBack();
  }

  void lightTheme(context) {
    BlocProvider.of<ThemeBloc>(context)
        .add(const ChangeTheme(useDeviceTheme: false, isDark: false));
    // getIt<NavigationService>().goBack();
  }

  void darkTheme(context) {
    BlocProvider.of<ThemeBloc>(context)
        .add(const ChangeTheme(useDeviceTheme: false, isDark: true));
    // getIt<NavigationService>().goBack();
  }
}
