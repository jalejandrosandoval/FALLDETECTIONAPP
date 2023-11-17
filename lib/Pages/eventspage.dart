import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EventsPageMain();
  }
}

class EventsPageMain extends StatefulWidget{
  const EventsPageMain({super.key});
  
  @override
  State<EventsPageMain> createState() => EventsPageState();
}

class EventsPageState extends State<EventsPageMain>{
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Eventos')),
    );
  }
}