import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../events/track_order_event.dart';
import '../states/track_order_state.dart';

class TrackOrderBloc extends Bloc<TrackOrderEvent, TrackOrderState> {
  late DocumentSnapshot orderSnapshot;
  late LatLng destination;
  StreamSubscription? orderSubscription;

  TrackOrderBloc() : super(TrackOrderLoading()) {
    on<StartTrackingEvent>(_onStartTracking);
    on<WorkerLocationUpdated>(_onWorkerLocationUpdated);
    on<StopTrackingEvent>(_onStopTracking);
  }

  Future<void> _onStartTracking(StartTrackingEvent event, Emitter<TrackOrderState> emit) async {
    emit(TrackOrderLoading());
    try {
      orderSubscription = FirebaseFirestore.instance
          .collection('orders')
          .doc(event.orderId)
          .snapshots()
          .listen((orderSnapshot) {
        destination = LatLng(orderSnapshot['latitude'], orderSnapshot['longitude']);
        final workerLocationMap = orderSnapshot['workerLocation'];
        final workerLocation = LatLng(workerLocationMap['latitude'], workerLocationMap['longitude']);
        add(WorkerLocationUpdated(workerLocation));
      });

      emit(TrackOrderLoaded(destination: destination));
    } catch (e) {
      emit(TrackOrderError(e.toString()));
    }
  }

  void _onWorkerLocationUpdated(WorkerLocationUpdated event, Emitter<TrackOrderState> emit) {
    if (state is TrackOrderLoaded) {
      final loadedState = state as TrackOrderLoaded;
      emit(TrackOrderLoaded(destination: loadedState.destination, currentPosition: event.workerLocation));
    }
  }

  Future<void> _onStopTracking(StopTrackingEvent event, Emitter<TrackOrderState> emit) async {
    await orderSubscription?.cancel();
    emit(TrackOrderLoading());
  }
}