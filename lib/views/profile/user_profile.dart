import 'package:hive_flutter/hive_flutter.dart';
part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String number;
  @HiveField(2)
  String email;
  @HiveField(3)
  String imagePath;

  UserProfile({required this.name, required this.number, required this.email, required this.imagePath});
}