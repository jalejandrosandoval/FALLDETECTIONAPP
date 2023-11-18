import 'package:falldetectionapp/Components/login.dart';
import 'package:falldetectionapp/Pages/eventspage.dart';
import 'package:falldetectionapp/Pages/fallspage.dart';
import 'package:falldetectionapp/Pages/ubicationpage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng? latLng;
dynamic userData;

class NavBarComponent extends StatelessWidget {
  final LatLng? latIngParam;
  final dynamic userDataParam;

  const NavBarComponent({Key? key, this.latIngParam, required this.userDataParam}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    latLng = latIngParam;
    userData = userDataParam;
    return const NavigationMain();
  }
}

class NavigationMain extends StatefulWidget {
  const NavigationMain({super.key});

  @override
  State<NavigationMain> createState() => _NavigationMainState();
}

class _NavigationMainState extends State<NavigationMain> {
  int currentPageIndex = 0;

  var optionsCuidador = const <Widget>[
    NavigationDestination(
      selectedIcon: Icon(Icons.location_on, color: Colors.blue),
      icon: Icon(Icons.location_on_outlined, color: Colors.orange),
      label: 'Ubicación',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.event_busy, color: Colors.orange),
      icon: Icon(Icons.event_busy_outlined, color: Colors.orange),
      label: 'Eventos'
    )
  ];

  var optionsClient = const <Widget>[
    NavigationDestination(
      selectedIcon: Icon(Icons.emergency_recording, color: Colors.blue ),
      icon: Icon(Icons.emergency_recording_outlined, color: Colors.orange ),
      label: 'Riesgo de Caidas',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.location_on, color: Colors.blue),
      icon: Icon(Icons.location_on_outlined, color: Colors.orange),
      label: 'Ubicación',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if(userData != null)
    {
      return Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: userData["tipo"].toString().toLowerCase() == "cuidador" ? optionsCuidador : optionsClient
        ),
        appBar: AppBar(title: const Text('FALL DETECTION APP')),
        body: (userData["tipo"].toString().toLowerCase() == "cuidador" ? 
          <Widget>[
            // ignore: prefer_null_aware_operators
            UbicationPage(latIngParam: (latLng != null ? latLng! : null)),
            EventsPage(userDataParam: userData),
          ][currentPageIndex] :
          <Widget>[
            FallsPage(userDataParam: userData),
            UbicationPage(userDataParam: userData),
          ][currentPageIndex]
        )
      );
    }else{
      return const Scaffold(
        body: LoginComponent(),
      );
    }
  }
}
