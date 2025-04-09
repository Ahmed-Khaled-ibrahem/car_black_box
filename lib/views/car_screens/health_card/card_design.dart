import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CarHealthCard extends StatelessWidget {
  final String name;
  final String age;
  final String bloodType;
  final String diseases;
  final String medications;

  const CarHealthCard({
    required this.name,
    required this.age,
    required this.bloodType,
    required this.diseases,
    required this.medications,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String qrData =
        "Name: $name\nAge: $age\nBlood Type: $bloodType\nDiseases: $diseases\nMedications: $medications";

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent], // Gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16), // Rounded corners
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(2, 4), // Soft shadow effect
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.numbers_rounded, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      "$age years",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.local_hospital, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        diseases.split(',').join('\n'),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Medications
                Row(
                  children: [
                    const Icon(Icons.medical_services, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        medications.split(',').join('\n'),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // QR Code
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                const Icon(
                  Icons.bloodtype,
                  color: Colors.greenAccent,
                  size: 40,
                ),
                Text(
                  bloodType,
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 20),
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 100,
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
