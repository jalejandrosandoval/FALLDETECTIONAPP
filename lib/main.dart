import 'package:falldetectionapp/Pages/initpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    const FirebaseOptions firebaseConfig  = FirebaseOptions(
      apiKey: "AIzaSyCsMjYKPPq4t03jKgDxEnnwGIiZGcU6BQA",
      authDomain: "myfailapp-6e9ce.firebaseapp.com",
      databaseURL: "https://myfailapp-6e9ce-default-rtdb.firebaseio.com",
      projectId: "myfailapp-6e9ce",
      storageBucket: "myfailapp-6e9ce.appspot.com",
      messagingSenderId: "917758134506",
      appId: "1:917758134506:web:c5d7dc9b78ba3cc9c82f93"
    );
    await Firebase.initializeApp(options: firebaseConfig );
    runApp(const MainApp());
  }

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        scaffoldBackgroundColor: Colors.white,       
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('FALL DETECTION APP')),
        body: const InitPage()
      )
    );
  }
}