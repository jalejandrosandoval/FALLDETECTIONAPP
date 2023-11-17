import 'package:falldetectionapp/Components/login.dart';
import 'package:flutter/material.dart';

class InitPage extends StatelessWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Bienvenido...",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
            ),
            Image.asset("/images/welcome.png"),
            FloatingActionButton.extended(
              backgroundColor: Colors.teal[400],
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) { return const LoginComponent(); })
                )
              },
              label: const Text('Login'),
            ),
          ]
        )
      )
    );
  }
}
