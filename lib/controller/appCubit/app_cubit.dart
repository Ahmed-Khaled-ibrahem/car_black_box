import 'package:car_black_box/models/car.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../services/firebase_auth.dart';
import '../../services/firebase_real_time.dart';
import '../../services/get_it.dart';
import '../../services/send_sms.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  List<Car> cars = [];

  void init() async {
    debugPrint("init");
    readData();
    getIt<FirebaseRealTimeDB>().listenToChange();
  }

  void refresh() async {
    state is Refresh ? emit(RefreshExtend()) : emit(Refresh());
  }

  Future readData() async {
    cars = await getIt<FirebaseRealTimeDB>().getData();
    refresh();
  }

  void checkAlert() async {
    for (var element in cars) {
      String myID = getIt<FirebaseAuthRepo>().currentUser!.uid.toString();
      if (element.owners?.contains(myID) ?? false) {
        if (element.risk) {
          EasyLoading.showInfo("Accident Alert");
          SendSms sendSms = SendSms();
          sendSms.sendToContacts();
          getIt<FirebaseRealTimeDB>().setRiskToFalse(element.id);
        }
      }
    }
  }
}
