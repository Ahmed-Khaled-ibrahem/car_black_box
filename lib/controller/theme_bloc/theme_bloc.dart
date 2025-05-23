import 'package:car_black_box/controller/theme_bloc/theme_event.dart';
import 'package:car_black_box/controller/theme_bloc/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/theme_service.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ChangeTheme>((event, emit) async {
      ThemeService.setTheme(useDeviceTheme: event.useDeviceTheme, isDark: event.isDark);
      emit(ThemeState(useDeviceTheme: event.useDeviceTheme, isDark: event.isDark));
    });
  }
}
