import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UbicationPage extends StatelessWidget {
  const UbicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UbicationPageMain();
  }
}

class UbicationPageMain extends StatefulWidget {
  const UbicationPageMain({super.key});
  @override
  State<UbicationPageMain> createState() => UbicationPageState();
}

class UbicationPageState extends State<UbicationPageMain> {

  static final Location _location = Location();
  static LatLng _currentLocation = const LatLng(0, 0);
  static CameraPosition _currentPosition = 
      CameraPosition(target: _currentLocation);

  // late GoogleMapController mapController;
  // late Location location = Location();
  // late LatLng currentLocation = LatLng(0, 0);
  // late CameraPosition currentPosition = CameraPosition(target: LatLng(4.570868, -74.297333), zoom: 5);

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  _getLocation() async {
    try {
      await _location.getLocation().then((location) => {
        setState(() {
          _currentLocation =
              LatLng(location.latitude!, location.longitude!);
          _currentPosition = CameraPosition(
            target: _currentLocation,
            zoom: 15,
          );
        })
      }
      );
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition.target == const LatLng(0, 0) ? const Center(child: Text('Cargando la ubicación...')) : Center(
          child: GoogleMap(
            initialCameraPosition: _currentPosition,
            markers: {
              Marker(
                  markerId: const MarkerId("userLocation"),
                  position: _currentLocation,
                  infoWindow: InfoWindow(
                    title: "Tu Ubicación:",
                    snippet:
                        "Latitud: ${_currentLocation.latitude}, Longitud: ${_currentLocation.longitude}",
                  ),
                  onTap: () {}),
        },
      )
      ),
    );
  }
}
