import 'package:firebase_database/firebase_database.dart';
import '../controller/appCubit/app_cubit.dart';
import '../models/car.dart';
import 'firebase_auth.dart';
import 'get_it.dart';

class FirebaseRealTimeDB {
  final _database = FirebaseDatabase.instance.ref();

  // Future<void> addData(Device device) async {
  //   await _database.child('devices').push().set(device.toJson());
  // }

  Future<bool> addDevice(
      String id, String pass, String userId, String name, int selected) async {
    var device = await _database.child('cars').child(id).once();
    if (device.snapshot.value == null) {
      return false;
    }
    Map? deviceMap = device.snapshot.value as Map?;
    String deviceRealPass = deviceMap?['pass'];
    if (deviceRealPass != pass) {
      return false;
    }

    String deviceOwners = deviceMap?['owners'] ?? '';
    String val = '$deviceOwners,$userId';

    await _database
        .child('cars')
        .child(id)
        .update({'owners': val, 'name': name, 'image': selected});
    return true;
  }

  Future<List<Car>> getData() async {
    final snapshot = await _database.child('cars').once();
    final devicesMap = snapshot.snapshot.value as Map?;

    List<Car>? devicesList = devicesMap?.entries
        .map((entry) {
          return Car.fromJson(entry);
        })
        .cast<Car>()
        .toList();

    return devicesList ?? [];
  }

  void listenToChange() {
    _database.child('cars').onValue.listen((event) {
      print('Data changed');
      getIt<AppCubit>().readData();
    });
  }

  void putSupportMessage(String topic, String message) {
    Map node = {
      'topic': topic,
      'message': message,
      'userId': getIt<FirebaseAuthRepo>().currentUser!.uid,
      'date': DateTime.now().toString(),
      'email': getIt<FirebaseAuthRepo>().currentUser!.email,
      'name': getIt<FirebaseAuthRepo>().currentUser!.displayName,
    };
    _database
        .child('support')
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .set(node);
  }

// Future<void> updateData(Device device) async {
//   await _database.child('devices').child(device.id).update(device.toJson());
// }
//
  Future<void> deleteCar(String id) async {
    await _database.child('cars').child(id).remove();
  }
}
