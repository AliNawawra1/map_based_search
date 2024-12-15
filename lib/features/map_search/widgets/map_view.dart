import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatelessWidget {
  final Set<Marker> markers;
  final String? mapStyle;
  final Function(GoogleMapController)? onMapCreated;

  const GoogleMapView(
      {super.key, required this.markers, this.mapStyle, this.onMapCreated});

  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(19.0759837, 72.8776559),
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _kGoogle,
      onMapCreated: onMapCreated,
      markers: markers,
      style: mapStyle,
    );
  }
}
