import 'package:falldetectionapp/Components/navbar.dart';
import 'package:falldetectionapp/Components/register.dart';
import 'package:flutter/material.dart';

class LoginComponent extends StatelessWidget {
  const LoginComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginMain();
  }
}

class LoginMain extends StatefulWidget {
  const LoginMain({super.key});

  @override
  State<LoginMain> createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  bool isRegistered = false, isLoggedIn = false, _hidePassword = false; 
  static const Color _colorForms = Colors.lightBlue;

  TextEditingController userNameController = TextEditingController(); 
  TextEditingController userPasswordController = TextEditingController(); 

  _Register(){
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) { return const RegisterComponent(); })
      );
    });
  }

  _Login() async {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) { return const NavBarComponent(); })
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return const NavBarComponent();
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('FALL DETECTION APP')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("/images/login.png"),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  controller: userNameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person_2_outlined),
                    labelText: 'Usuario...',
                    hintText: 'Usuario...',
                    iconColor: _colorForms,
                  )
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
                      icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off, color: _colorForms),
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    )
                  ),
                  obscureText: _hidePassword ? false : true
                ),
              ),
              FloatingActionButton.extended(
                onPressed: _Login,
                icon: const Icon(Icons.login_outlined),
                label: const Text('Iniciar Sesión')
              ),
              const Text(''),
              TextButton(
                onPressed: _Register, 
                child: const Text('¿No tienes una cuenta? Regístrate aquí...', style: TextStyle(color: Colors.black),),
              )
            ],
          ),
        ),
      );
    }
  }
}