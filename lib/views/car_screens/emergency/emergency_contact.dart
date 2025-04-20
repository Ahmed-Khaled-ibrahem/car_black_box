import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'emergency_contact.g.dart';

@HiveType(typeId: 4)
class EmergencyContact extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String phone;

  EmergencyContact({required this.name, required this.phone});

  // Helper method to get IconData from codePoint
  // IconData get icon => Icon(iconCode).icon;
}
