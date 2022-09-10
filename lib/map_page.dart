import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GoogleMap(
        compassEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        myLocationEnabled: true,
        initialCameraPosition:
            CameraPosition(target: LatLng(10.4229123, -75.5480038), zoom: 15),

        // ignore: invalid_use_of_protected_member
      ),
    );
  }
}
