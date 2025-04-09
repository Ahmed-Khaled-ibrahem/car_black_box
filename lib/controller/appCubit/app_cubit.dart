import 'package:car_black_box/models/car.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/firebase_real_time.dart';
import '../../services/get_it.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  List<Car> cars = [];

  void init() async{
    debugPrint("init");
    readData();
    getIt<FirebaseRealTimeDB>().listenToChange();
  }

  void refresh() async{
    state is Refresh ?  emit(RefreshExtend()) : emit(Refresh());
  }

  Future readData() async{
    cars = await getIt<FirebaseRealTimeDB>().getData();
    refresh();
  }


}

