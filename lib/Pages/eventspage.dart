import 'package:falldetectionapp/Components/navbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

dynamic userData;

class EventsPage extends StatelessWidget {
  final dynamic userDataParam;
  const EventsPage({Key? key, this.userDataParam}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userData = userDataParam;
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
  static const Color _colorForms = Colors.lightBlue;

  String? userName, userPassword;
  String userNameSearch = "", latitud = "", longitud = "";

  Object listData = [];

  _getSearch(String param) async{  
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('caidas');
    
    dbRef.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Object values = dataSnapshot.value!;
      setState(() {
        listData = values;
        print(listData);
      });
    });
  }

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('caidas');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding( 
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (value) => 
              {
                setState((){
                  userNameSearch = value;
                }),
                _getSearch(value)
              },
              decoration: InputDecoration(
                icon: IconButton(
                  icon: const Icon(Icons.search_outlined), 
                  onPressed: () { 
                    _getSearch(userNameSearch);
                  }
                ),
                labelText: 'Buscar...',
                hintText: 'Buscar...',
                iconColor: _colorForms,
              )
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20.0)),
            FirebaseAnimatedList(
              query: databaseReference,
              shrinkWrap: true,
              itemBuilder: (context, snapshot, animation, index) {
                Map contact = snapshot.value as Map;
                contact['key'] = snapshot.key;
                return SingleChildScrollView(
                  child: 
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        child: ListTile(
                          dense: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) { 
                                return NavBarComponent(
                                  latIngParam: LatLng(contact['latitud'], contact['longitud']), 
                                  userDataParam: userData
                                ); 
                              })
                            );
                          },
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red[700]),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Eliminar Registo..."),
                                    content: const Text("¿Está realmente seguro?"),
                                    actions: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context).textTheme.labelLarge,
                                        ), 
                                        onPressed: () { Navigator.pop(context, false); }, 
                                        child: const Text("Cancelar")
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context).textTheme.labelLarge,
                                        ),
                                        onPressed: () { databaseReference.child(contact['key']).remove().then((value) => Navigator.pop(context, false)); }, 
                                        child: const Text("Ok")
                                      ),
                                    ]
                                  );
                                },
                              );
                            },
                          ),
                          title: 
                          Text(
                            contact['nombre'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                          ),
                          subtitle: Text(
                            'Aceleración: ${contact['aceleracion']} m/s^2. \nUbicación: (Latitud: ${contact['latitud']}, Longitud: ${contact['longitud']}. \nFecha: ${contact["fecha"]})',
                            style: const TextStyle(fontSize: 13)
                          ),
                          isThreeLine: true
                        )
                      )
                    ),
                );
                // );
              }
            )
          ]
        )
      )
    );
  }
}
         