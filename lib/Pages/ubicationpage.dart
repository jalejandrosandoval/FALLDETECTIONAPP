import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

LatLng? latLng;
dynamic userData;

class UbicationPage extends StatelessWidget {
  final dynamic userDataParam;
  final LatLng? latIngParam;
  const UbicationPage({Key? key, this.latIngParam, this.userDataParam}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    latLng = latIngParam;
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

  static LatLng _currentLocation = const LatLng(0, 0), _currentLocationFall = const LatLng(0, 0);
  static CameraPosition _currentPosition = CameraPosition(target: _currentLocation);

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  _getLocation() async {
    try {
      await _location.getLocation().then((location) => {
        setState(() {
          _currentLocation = LatLng(location.latitude!, location.longitude!);
          _currentPosition = CameraPosition(
            target: _currentLocation,
            zoom: 15,
          );
        })
      });

      if (_currentLocation != const LatLng(0, 0)){
        setState(() {
          _currentLocationFall = latLng!;
        });
      }
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    }
  }
  
  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null || x1 == null || y0 == null || y1 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }

    return LatLngBounds(northeast: LatLng(x1!, y1!),southwest:  LatLng(x0!, y0!));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition.target == const LatLng(0, 0)
          ? const Center(child: Text('Cargando la ubicación...'))
          : Center(
              child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              padding: const EdgeInsets.only(top: 40.0),
              initialCameraPosition: _currentPosition,
              compassEnabled: true,
              onMapCreated: (controller) => {
                setState((){
                  if(_currentLocationFall != const LatLng(0, 0)){
                    var latBounds = boundsFromLatLngList([_currentLocation, _currentLocationFall]);
                    controller.animateCamera(CameraUpdate.newLatLngBounds(latBounds, 0.0));
                  }
                })
              },
              markers: {
                Marker(
                  markerId: const MarkerId("userLocation"),
                  position: _currentLocation,
                  infoWindow: InfoWindow(
                    title: "Tu Ubicación:",
                    snippet: "Latitud: ${_currentLocation.latitude}, Longitud: ${_currentLocation.longitude}",
                  ),
                ),
                Marker(
                  markerId: const MarkerId("userLocationFall"),
                  visible: _currentLocationFall != const LatLng(0, 0) ? true : false,
                  position: _currentLocationFall,
                  infoWindow: InfoWindow(
                    title: "Ubicación Caída:",
                    snippet: "Latitud: ${_currentLocationFall.latitude}, Longitud: ${_currentLocationFall.longitude}",
                  ),
                )
              },
            )),
    );
  }
}
