import 'package:hive/hive.dart';
part 'car.g.dart'; // Auto-generated file

@HiveType(typeId: 1)
class Car extends HiveObject {
  @HiveField(0)
  String carNumber;

  @HiveField(1)
  String carModel;

  @HiveField(2)
  String ownerName;

  @HiveField(3)
  String ownerPhone;

  @HiveField(4)
  String insuranceDetails;

  Car(this.carNumber, this.carModel, this.ownerName, this.ownerPhone, this.insuranceDetails);
}
