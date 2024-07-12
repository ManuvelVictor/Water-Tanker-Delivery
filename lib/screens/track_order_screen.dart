import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../blocs/track_order_bloc.dart';
import '../events/track_order_event.dart';
import '../states/track_order_state.dart';

class TrackOrderScreen extends StatefulWidget {
  final String orderID;

  const TrackOrderScreen({
    super.key,
    required this.orderID,
  });

  @override
  TrackOrderScreenState createState() => TrackOrderScreenState();
}

class TrackOrderScreenState extends State<TrackOrderScreen> {
  late GoogleMapController _controller;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  BitmapDescriptor? personIcon;
  late final LatLng _destination = const LatLng(11.081206902432173, 76.94137929896259);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TrackOrderBloc>(context).add(StartTrackingEvent(widget.orderID));
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    personIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/user.png',
    );
  }

  @override
  void dispose() {
    BlocProvider.of<TrackOrderBloc>(context).add(StopTrackingEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        centerTitle: true,
      ),
      body: BlocBuilder<TrackOrderBloc, TrackOrderState>(
        builder: (context, state) {
          if (state is TrackOrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TrackOrderLoaded) {
            _markers.add(
              Marker(
                markerId: const MarkerId('destination'),
                position: _destination,
                infoWindow: const InfoWindow(title: 'Destination'),
              ),
            );
            if (state.currentPosition != null) {
              _markers.add(
                Marker(
                  markerId: const MarkerId('worker'),
                  position: state.currentPosition!,
                  icon: personIcon ?? BitmapDescriptor.defaultMarker,
                  infoWindow: const InfoWindow(title: 'Worker Location'),
                ),
              );
            }
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _destination,
                zoom: 14,
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            );
          } else if (state is TrackOrderError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Start tracking the order.'));
          }
        },
      ),
    );
  }
}