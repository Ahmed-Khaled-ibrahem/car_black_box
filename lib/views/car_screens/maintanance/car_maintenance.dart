import 'package:hive_flutter/hive_flutter.dart';
part 'car_maintenance.g.dart';

@HiveType(typeId: 3)
class CarMaintenance extends HiveObject {
  @HiveField(0)
  DateTime? lastBatteryCheck;

  @HiveField(1)
  DateTime? nextBatteryCheck;

  @HiveField(2)
  DateTime? lastOilChange;

  @HiveField(3)
  DateTime? nextOilChange;

  @HiveField(4)
  DateTime? lastTireCheck;

  @HiveField(5)
  DateTime? nextTireCheck;

  @HiveField(6)
  String? notes;

  CarMaintenance({
     this.lastBatteryCheck,
     this.nextBatteryCheck,
     this.lastOilChange,
     this.nextOilChange,
     this.lastTireCheck,
     this.nextTireCheck,
     this.notes,
  });
}