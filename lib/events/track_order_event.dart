import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TrackOrderEvent {}

class StartTrackingEvent extends TrackOrderEvent {
  final String orderId;
  StartTrackingEvent(this.orderId);
}

class StopTrackingEvent extends TrackOrderEvent {}

class WorkerLocationUpdated extends TrackOrderEvent {
  final LatLng workerLocation;
  WorkerLocationUpdated(this.workerLocation);
}