import 'package:falldetectionapp/Pages/eventspage.dart';
import 'package:falldetectionapp/Pages/fallspage.dart';
import 'package:falldetectionapp/Pages/ubicationpage.dart';
import 'package:flutter/material.dart';

class NavBarComponent extends StatelessWidget {
  const NavBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
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
          NavigationDestination(
            selectedIcon: Icon(Icons.event_busy, color: Colors.orange),
            icon: Icon(Icons.event_busy_outlined, color: Colors.orange),
            label: 'Eventos',
          ),
        ],
      ),
      body: <Widget>[
        FallsPage(),
        UbicationPage(),
        EventsPage(),
      ][currentPageIndex],
    );
  }
}
