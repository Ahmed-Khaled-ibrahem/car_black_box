import 'package:hive/hive.dart';
part 'trip_model.g.dart';

@HiveType(typeId: 6)
class TripModel {
  @HiveField(0)
  String tripName;

  @HiveField(1)
  String startLocation;

  @HiveField(2)
  String startTime;

  @HiveField(3)
  String endTime;

  @HiveField(4)
  String endLocation;

  @HiveField(5)
  String route;

  @HiveField(6)
  String dateOfTrip;

  TripModel({
    required this.tripName,
    required this.startLocation,
    required this.startTime,
    required this.endTime,
    required this.endLocation,
    required this.route,
    required this.dateOfTrip,
  });
}
