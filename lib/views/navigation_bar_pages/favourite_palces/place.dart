import 'package:hive/hive.dart';
part 'place.g.dart'; // Generated file after running build_runner

@HiveType(typeId: 10)
class Place extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double latitude;

  @HiveField(2)
  double longitude;

  Place({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}