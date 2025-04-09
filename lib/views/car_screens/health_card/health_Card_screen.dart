import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../../profile/user_profile.dart';
import 'car_health.dart';
import 'card_design.dart';

class CarHealthPage extends StatefulWidget {
  @override
  _CarHealthPageState createState() => _CarHealthPageState();
}

class _CarHealthPageState extends State<CarHealthPage> {
  final _carHealthBox = Hive.box<CarHealth>('car_health');
  final _formKey = GlobalKey<FormState>();
  String profileName = '';
  final _profileBox = Hive.box<UserProfile>('profileBox');

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController bloodTypeController = TextEditingController();
  TextEditingController diseasesController = TextEditingController();
  TextEditingController medicationsController = TextEditingController();

  final List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];
  String? selectedBloodType;

  void _saveCarHealth() {
    if (_formKey.currentState!.validate()) {
      final newCarHealth = CarHealth(
        nameController.text,
        int.parse(ageController.text == '' ? '0' : ageController.text),
        bloodTypeController.text,
        diseasesController.text,
        medicationsController.text,
      );
      _carHealthBox.put('car_health_info', newCarHealth);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car health details saved!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final savedCarHealth = _carHealthBox.get('car_health_info');
    if (savedCarHealth != null) {
      nameController.text = savedCarHealth.name;
      ageController.text = savedCarHealth.age.toString() == '0' ? '' : savedCarHealth.age.toString();
      bloodTypeController.text = savedCarHealth.bloodType;
      selectedBloodType = savedCarHealth.bloodType;
      diseasesController.text = savedCarHealth.diseases;
      medicationsController.text = savedCarHealth.medications;
    }
    final profile = _profileBox.get('profile');
    if (profile != null) {
      profileName = profile.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Car Health Info')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                   CarHealthCard(
                    name: nameController.text,
                    age: ageController.text,
                    bloodType: selectedBloodType ?? '',
                    diseases: diseasesController.text,
                    medications: medicationsController.text,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.person),
                        labelText: 'Name',
                        suffixIcon: TextButton(
                            onPressed: () {
                              setState(() {
                                nameController.text = profileName;
                              });
                            },
                            child: const Text('Me')),
                        border: const OutlineInputBorder(),
                        hintText: 'Enter name'),
                    // validator: (value) => value!.isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    // Numeric Keyboard
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    // Restricts input to numbers
                    decoration: const InputDecoration(
                        icon: Icon(Icons.numbers),
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                        hintText: 'Enter age'),
                    // validator: (value) => value!.isEmpty ? 'Enter age' : null,
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: selectedBloodType,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.bloodtype),
                        labelText: 'Blood Type',
                        border: OutlineInputBorder(),
                        hintText: 'Enter blood type'),
                    items: bloodTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBloodType = value;
                        bloodTypeController.text = value ?? '';
                      });
                    },
                    // validator: (value) =>
                    //     value == null ? 'Select blood type' : null,
                  ),

                  const SizedBox(height: 10),
                  TextFormField(
                    controller: diseasesController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.health_and_safety),
                        labelText: 'Diseases',
                        border: OutlineInputBorder(),
                        hintText: 'Enter diseases separated by commas'),
                    // validator: (value) => value!.isEmpty ? 'Enter diseases' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: medicationsController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.medication),
                        labelText: 'Medications',
                        hintText: 'Enter medications separated by commas',
                        border: OutlineInputBorder()),
                    // validator: (value) => value!.isEmpty ? 'Enter medications' : null,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveCarHealth,
                      child: const Text('Save Health Information'),
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
