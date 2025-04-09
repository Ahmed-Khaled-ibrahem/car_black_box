import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'emergency_contact.g.dart';

@HiveType(typeId: 4)
class EmergencyContact extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String phone;

  @HiveField(2)
  int iconCode; // Store icon as an integer

  EmergencyContact({required this.name, required this.phone, required this.iconCode});

  // Helper method to get IconData from codePoint
  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');
}
