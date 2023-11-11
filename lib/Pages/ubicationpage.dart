import 'package:flutter/material.dart';

class UbicationPage extends StatelessWidget {
  const UbicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UbicationPageMain();
  }
}

class UbicationPageMain extends StatefulWidget{
  const UbicationPageMain({super.key});
    @override
  State<UbicationPageMain> createState() => UbicationPageState();
}

class UbicationPageState extends State<UbicationPageMain>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Ubicación')),
    );
  }
}