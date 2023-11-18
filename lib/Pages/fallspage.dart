import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:firebase_database/firebase_database.dart';

dynamic userData;

class FallsPage extends StatelessWidget {
  final dynamic userDataParam;
  const FallsPage({Key? key, this.userDataParam}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userData = userDataParam;
    return const FallsPageMain();
  }
}

class FallsPageMain extends StatefulWidget {
  const FallsPageMain({super.key});
  @override
  State<FallsPageMain> createState() => FallsPageState();
}

class FallsPageState extends State<FallsPageMain> {
  late StreamSubscription<AccelerometerEvent> subscription;
  double fallThresholdHigh = 16.0;
  double fallThresholdMedium = 13.0;
  String fallRisk = 'Sin datos';
  String accelerometerValue = '0.0';
  bool isFallDetected = false;
  Color circleColor = Colors.green; // Color predeterminado

  List<double> accelerationBuffer = [];
  int bufferLength = 10;

  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    startListening();
  }

  void _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      // El usuario no otorgó permisos de ubicación, puedes manejar esto como desees
      print('Permiso de ubicación no otorgado');
    }
  }

  void startListening() {
    subscription = accelerometerEvents.listen((AccelerometerEvent event) {
      double smoothedAcceleration = applyFilter(event);
      detectFall(smoothedAcceleration);
    });
  }

  double applyFilter(AccelerometerEvent event) {
    accelerationBuffer.add(calculateTotalAcceleration(event));
    if (accelerationBuffer.length > bufferLength) {
      accelerationBuffer.removeAt(0);
    }

    double sum = accelerationBuffer.reduce((a, b) => a + b);
    double average = sum / accelerationBuffer.length;
    setState(() {
      accelerometerValue = average.toStringAsFixed(2);
    });
    return average;
  }

  double calculateTotalAcceleration(AccelerometerEvent event) {
    return sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
  }

  void detectFall(double smoothedAcceleration) async {
    if (!isFallDetected) {
      if (smoothedAcceleration > fallThresholdHigh) {
        setState(() {
          isFallDetected = true;
          fallRisk = 'Caída detectada';
          circleColor = Colors.red; // Cambia el color del círculo a rojo
        });
        await _getRealTimeLocation(); // Espera a obtener la ubicación en tiempo real
        sendFallInformation();
        sendEmail();
        saveInfo();
      } else if (smoothedAcceleration >= fallThresholdMedium) {
        setState(() {
          fallRisk = 'Alto riesgo de caída';
          circleColor = Colors.yellow; // Cambia el color del círculo a amarillo
        });
      } else {
        setState(() {
          isFallDetected = false;
          fallRisk = 'Riesgo de caída bajo';
          circleColor = Colors.green; // Cambia el color del círculo a verde
        });
      }
    } else {
      // Restablecer el estado cuando la aceleración vuelva a niveles normales
      if (smoothedAcceleration < fallThresholdMedium) {
        setState(() {
          isFallDetected = false;
          fallRisk = 'Sin datos';
          circleColor = Colors.green; // Restablece el color a verde
        });
      }
    }
  }

  Future<void> _getRealTimeLocation() async {
    if (await Permission.location.request().isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );

        // Actualiza el estado con la nueva información de geolocalización
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
      } catch (e) {
        print('Error obteniendo la ubicación: $e');
      }
    } else {
      print('Permiso de ubicación denegado');
    }
  }

  void sendFallInformation() {
    // Puedes implementar la lógica para guardar las coordenadas aquí.
    // Por ahora, simplemente imprime un mensaje.
    print('Caída detectada. Guardar información crucial...');
    // Puedes agregar la lógica para obtener y mostrar la ubicación aquí.
  }

  void sendEmail() async {
    // Configura el servidor SMTP para enviar el correo
    final smtpServer = gmail('flosada@unab.edu.co', '63559.Mal');

    // Crea el mensaje de correo
    final message = Message()
      ..from = const Address('flosada@unab.edu.co', 'Faiber Losada')
      ..recipients.add('flosada@unab.edu.co') // Correo de destino
      ..recipients.add('bsanchez294@unab.edu.co') // Correo de destino
      ..recipients.add('jsandoval568@unab.edu.co') // Correo de destino
      ..subject = 'Alerta de Caída Detectada'
      ..text =
          'Se detectó una caída en las coordenadas: Latitud: $latitude, Longitud: $longitude';

    // Envía el correo electrónico
    try {
      final sendReport = await send(message, smtpServer);
      print('Correo enviado: $sendReport');
    } catch (e) {
      print('Error al enviar el correo: $e');
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  accelerometerValue,
                  style: const TextStyle(fontSize: 48, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isFallDetected)
              Text(
                'Coordenadas de Google Maps: Latitud: $latitude, Longitud: $longitude',
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
            const SizedBox(height: 16),
            Text(
              fallRisk,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

DatabaseReference? dbRef;

  saveInfo() async {
    dbRef = FirebaseDatabase.instance.ref().child('caidas');
    String nombre = "Horacio", apellido = "Serpa";
    int idUsuario = 4;
     final now = DateTime.now();
     String fecha = now.toString();

     try {
        Map caidas= {
          'nombre': nombre,
          'apellido': apellido,
          'id_usuario': idUsuario,
          'latitud': latitude,
          'longitud': longitude,
          'aceleracion': accelerometerValue,
          'id_cuidador': 0,
          'fecha': fecha,
        };
        dbRef!.push().set(caidas);
    } on Exception catch (e) {
      print(e);
    }
  }
}