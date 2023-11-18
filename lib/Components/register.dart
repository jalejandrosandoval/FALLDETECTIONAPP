import 'package:falldetectionapp/Components/login.dart';
import 'package:flutter/material.dart';

class RegisterComponent extends StatelessWidget {
  const RegisterComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterMain();
  }
}

class RegisterMain extends StatefulWidget {
  const RegisterMain({super.key});

  @override
  State<RegisterMain> createState() => RegisterMainState();
}

class RegisterMainState extends State<RegisterMain> {
  bool isRegistered = false, isLoggedIn = false, _hidePassword = false;
  String? userName, userPassword;
  static const Color _colorForms = Colors.amber;

  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  _Register() {
    setState(() {});
  }

  _Login() async {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return const LoginComponent();
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FALL DETECTION APP')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Registrarse...",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Image.asset("assets/images/sign_in.png"),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                controller: userNameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person_2_outlined),
                  labelText: 'Usuario...',
                  hintText: 'Usuario...',
                  iconColor: _colorForms,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              padding: const EdgeInsets.only(bottom: 20.0),
              child: TextField(
                  controller: userPasswordController,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      iconColor: _colorForms,
                      labelText: 'Contraseña...',
                      hintText: 'Contraseña...',
                      suffixIcon: IconButton(
                        icon: Icon(
                            _hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: _colorForms),
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                      )),
                  obscureText: _hidePassword ? false : true),
            ),
            FloatingActionButton.extended(
                onPressed: _Register,
                icon: const Icon(Icons.how_to_reg_outlined),
                label: const Text('Registrarse...')),
            const Text(''),
            TextButton(
              onPressed: _Login,
              child: const Text(
                '¿Ya tienes una cuenta?, Inicia Sesión aquí...',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
