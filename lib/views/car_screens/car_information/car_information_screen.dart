
import 'package:car_black_box/views/car_screens/car_information/plat_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../profile/user_profile.dart';
import 'car.dart';

class CarInfoPage extends StatefulWidget {
  @override
  _CarInfoPageState createState() => _CarInfoPageState();
}

class _CarInfoPageState extends State<CarInfoPage> {
  final _carBox = Hive.box<Car>('cars');
  final _formKey = GlobalKey<FormState>();
  final _profileBox = Hive.box<UserProfile>('profileBox');

  TextEditingController carNumberController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController ownerPhoneController = TextEditingController();
  TextEditingController insuranceController = TextEditingController();
  String profileName = '';
  String profileNumber = '';

  void _saveCar() {
    if (_formKey.currentState!.validate()) {
      final newCar = Car(
        carNumberController.text,
        carModelController.text,
        ownerNameController.text,
        ownerPhoneController.text,
        insuranceController.text,
      );

      _carBox.put('car_info', newCar);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car details saved!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final savedCar = _carBox.get('car_info');
    if (savedCar != null) {
      carNumberController.text = savedCar.carNumber;
      carModelController.text = savedCar.carModel;
      ownerNameController.text = savedCar.ownerName;
      ownerPhoneController.text = savedCar.ownerPhone;
      insuranceController.text = savedCar.insuranceDetails;
    }
    final profile = _profileBox.get('profile');
    if (profile != null) {
      profileName = profile.name;
      profileNumber = profile.number;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Car Information')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                   CarPlateWidget(
                    plateNumber: carNumberController.text ,
                    regionCode: "KSA", // Change this based on the country
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: carNumberController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.numbers),
                        labelText: 'Car Plate Number',
                        hintText: 'Enter car number',
                        border: OutlineInputBorder()),
                    // validator: (value) => value!.isEmpty ? 'Enter car number' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: carModelController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.car_rental),
                        labelText: 'Car Model',
                        hintText: 'Enter car model',
                        border: OutlineInputBorder()),
                    // validator: (value) => value!.isEmpty ? 'Enter car model' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: ownerNameController,
                    decoration:  InputDecoration(
                        icon: const Icon(Icons.person),
                        suffixIcon: TextButton(onPressed: (){
                          setState(() {
                            ownerNameController.text = profileName;
                          });
                        }, child: const Text('Me')),
                        labelText: 'Owner Name',
                        hintText: 'Enter owner name',
                        border: const OutlineInputBorder()),
                    // validator: (value) => value!.isEmpty ? 'Enter owner name' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: ownerPhoneController,
                    decoration:  InputDecoration(
                        suffixIcon: TextButton(onPressed: (){
                          setState(() {
                            ownerPhoneController.text = profileNumber;
                          });
                        }, child: const Text('Me')),
                        icon: const Icon(Icons.phone),
                        labelText: 'Owner Phone',
                        hintText: 'Enter owner phone',
                        border: const OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                    // validator: (value) => value!.isEmpty ? 'Enter phone number' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: insuranceController,
                    decoration:  const InputDecoration(
                        icon: Icon(Icons.insights),
                        labelText: 'Insurance Details',
                        hintText: 'Enter insurance details',
                        border: OutlineInputBorder()),
                    // validator: (value) => value!.isEmpty ? 'Enter insurance details' : null,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveCar,
                      child: const Text('Save Car Information'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
