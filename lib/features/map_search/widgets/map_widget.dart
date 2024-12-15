import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatelessWidget {
  final Set<Marker> markers;
  final String? mapStyle;
  final Function(GoogleMapController)? onMapCreated;

  const GoogleMapView(
      {super.key, required this.markers, this.mapStyle, this.onMapCreated});

  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
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
