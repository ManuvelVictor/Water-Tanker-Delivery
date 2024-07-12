import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TrackOrderState {}

class TrackOrderLoading extends TrackOrderState {}

class TrackOrderLoaded extends TrackOrderState {
  final LatLng destination;
  final LatLng? currentPosition;

  TrackOrderLoaded({required this.destination, this.currentPosition});
}

class TrackOrderError extends TrackOrderState {
  final String message;

  TrackOrderError(this.message);
}