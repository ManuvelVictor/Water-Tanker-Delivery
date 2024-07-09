import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../events/home_event.dart';
import '../states/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState(selectedTanks: 1, currentLocationName: "Tap here to get current location")) {
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<SelectTanksEvent>(_onSelectTanks);
  }

  Future<void> _onUpdateLocation(UpdateLocationEvent event, Emitter<HomeState> emit) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      if (placeMarks.isNotEmpty) {
        emit(state.copyWith(
          currentLocationName: "${placeMarks.first.locality}, ${placeMarks.first.country}",
          latitude: position.latitude,
          longitude: position.longitude,
        ));
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  void _onSelectTanks(SelectTanksEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      selectedTanks: event.numberOfTanks,
    ));
  }
}
