import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ptv_api_client/model/v3_stops_by_distance_response.dart';

class MapWidget extends StatelessWidget {
  MapWidget(this.currentLat, this.currentLng, this.stopsResponse);
  final double currentLat;
  final double currentLng;
  final V3StopsByDistanceResponse stopsResponse;

  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLat, currentLng),
          zoom: 14.4746,
        ),
        markers: stopsResponse.stops
            .map(
              (stop) => Marker(
                markerId: MarkerId(stop.stopId.toString()),
                position: LatLng(stop.stopLatitude, stop.stopLongitude),
              ),
            )
            .toSet(),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
