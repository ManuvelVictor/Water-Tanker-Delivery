import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../events/home_event.dart';
import '../states/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState(selectedTanks: 1, currentLocationName: "Tap here to get current location")) {
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<SelectTanksEvent>(_onSelectTanks);
    on<PlaceOrderEvent>(_onPlaceOrder);
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
      const SnackBar(content: Text('Error updating location'));
    }
  }

  void _onSelectTanks(SelectTanksEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      selectedTanks: event.numberOfTanks,
    ));
  }

  Future<void> _onPlaceOrder(PlaceOrderEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isPlacingOrder: true, orderSuccess: false, orderFailure: null));
    final String userName = FirebaseAuth.instance.currentUser?.email ?? "Anonymous";
    final orderRef = FirebaseFirestore.instance.collection('orders').doc();
    try {
      await orderRef.set({
        'userName': userName,
        'numberOfTanks': state.selectedTanks,
        'location': state.currentLocationName,
        'latitude': state.latitude,
        'longitude': state.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });
      emit(state.copyWith(isPlacingOrder: false, orderSuccess: true));
    } catch (e) {
      emit(state.copyWith(isPlacingOrder: false, orderSuccess: false, orderFailure: e.toString()));
      const SnackBar(content: Text('Error placing order'));
    }
  }
}
