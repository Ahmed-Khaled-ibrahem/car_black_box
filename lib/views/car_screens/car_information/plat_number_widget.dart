import 'package:flutter/material.dart';

class CarPlateWidget extends StatelessWidget {
  final String plateNumber;
  final String regionCode;

  const CarPlateWidget({required this.plateNumber, required this.regionCode, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white, // Plate background color
        borderRadius: BorderRadius.circular(12), // Rounded edges
        border: Border.all(color: Colors.black, width: 3), // Black border
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 5,
            offset: Offset(2, 4), // Soft shadow effect
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Country / Region Code
          Container(
            width: 60,
            decoration: const BoxDecoration(
              color: Colors.blue, // Blue region color
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Text(
                regionCode,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          // Plate Number
          Expanded(
            child: Center(
              child: Text(
                plateNumber,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontFamily: 'Monospace',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
