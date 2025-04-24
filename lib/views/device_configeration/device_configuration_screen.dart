import 'package:car_black_box/controller/appCubit/app_cubit.dart';
import 'package:car_black_box/services/get_it.dart';
import 'package:car_black_box/views/device_configeration/qr_code_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../const/car_colors.dart';
import '../../services/firebase_auth.dart';
import '../../services/firebase_real_time.dart';

class DeviceConfigurationScreen extends StatefulWidget {
  const DeviceConfigurationScreen({super.key});

  @override
  State<DeviceConfigurationScreen> createState() =>
      _DeviceConfigurationScreenState();
}

class _DeviceConfigurationScreenState extends State<DeviceConfigurationScreen> {
  TextEditingController deviceIDController = TextEditingController();
  TextEditingController devicePassController = TextEditingController();
  TextEditingController deviceNameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int selected = 0;
  bool _obscureText = true;
  String? _scannedQRCode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
    builder: (context, state) {
      var cubit = getIt<AppCubit>();
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Device'),
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QRScannerScreen()),
                      );
                      if (result != null) {
                        setState(() {
                          _scannedQRCode = result;
                          deviceIDController.text = _scannedQRCode!;
                          devicePassController.text = _scannedQRCode!;
                        });
                      }
                    },
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Scan QR Code'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50), // Full-width button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: deviceIDController,
                    validator: (value) => value!.isEmpty ? 'Enter device ID' : null,
                    decoration: const InputDecoration(
                        labelText: 'Device ID',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: devicePassController,
                    validator: (value) => value!.isEmpty ? 'Enter device Password' : null,
                    obscureText: _obscureText,
                    decoration:  InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        labelText: 'Device Password',
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)))),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: deviceNameController,
                    validator: (value) =>
                    value!.isEmpty ? 'Enter device Name' : null,
                    decoration: const InputDecoration(
                        labelText: 'Device Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)))),
                  ),
                ),
                CarouselSlider(
                    items: carColors.map((e) => Image.asset(e,fit: BoxFit.cover)).toList(),
                    options: CarouselOptions(
                      height: 200,
                      viewportFraction: 0.9,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.7,
                      onPageChanged: (val, re){selected = val; print(selected);},
                      scrollDirection: Axis.horizontal,
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Connect'),
                      ],
                    ),
                    onPressed: () async{
                      if (formKey.currentState!.validate())  {
                        bool isAdded = await getIt<FirebaseRealTimeDB>().addDevice(
                            deviceIDController.text,
                            devicePassController.text,
                            getIt<FirebaseAuthRepo>().currentUser!.uid,
                            deviceNameController.text,
                          selected
                        );
                        if(isAdded){
                          Navigator.pop(context);
                          cubit.refresh();
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong Credentials'),));
                        }
                      }
                    },
                  ),
                ),
              ]),
            ),
          ),
        ),
      );
    },
    );
  }
}
