import 'package:flutter/material.dart';

class FallsPage extends StatelessWidget {
  const FallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FallsPageMain();
  }
}

class FallsPageMain extends StatefulWidget{
  const FallsPageMain({super.key});
    @override
  State<FallsPageMain> createState() => FallsPageState();
}

class FallsPageState extends State<FallsPageMain>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Caídas')),
    );
  }
}