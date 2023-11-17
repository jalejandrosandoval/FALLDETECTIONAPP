import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  // void firebase() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   const FirebaseOptions firebaseConfig  = FirebaseOptions(
  //     apiKey: "AIzaSyCsMjYKPPq4t03jKgDxEnnwGIiZGcU6BQA",
  //     authDomain: "myfailapp-6e9ce.firebaseapp.com",
  //     databaseURL: "https://myfailapp-6e9ce-default-rtdb.firebaseio.com",
  //     projectId: "myfailapp-6e9ce",
  //     storageBucket: "myfailapp-6e9ce.appspot.com",
  //     messagingSenderId: "917758134506",
  //     appId: "1:917758134506:web:c5d7dc9b78ba3cc9c82f93"
  //   );
  //   await Firebase.initializeApp(options: firebaseConfig );
  // }

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
  bool isRegistered = false, isLoggedIn = false; 
  String? userName, userPassword;
  String latitud = "", longitud = "";

  TextEditingController userNameController = TextEditingController(); 
  TextEditingController userPasswordController = TextEditingController(); 
  
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('caidas');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirebaseAnimatedList(
        query: databaseReference,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          Map Contact = snapshot.value as Map;
          Contact['key'] = snapshot.key;
          latitud = Contact['latitud'].toString();
          return GestureDetector(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.indigo[100],
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[900],
                    ),
                    onPressed: () {
                     databaseReference.child(Contact['key']).remove();
                    },
                  ),
                  title: Text(
                    Contact['nombre'],
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    latitud,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      )
    );
  }
}