import 'package:hive/hive.dart';
part 'car_health.g.dart'; // Auto-generated file

@HiveType(typeId: 2)
class CarHealth extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  String bloodType;

  @HiveField(3)
  String diseases;

  @HiveField(4)
  String medications;

  CarHealth(this.name, this.age, this.bloodType, this.diseases, this.medications);
}
