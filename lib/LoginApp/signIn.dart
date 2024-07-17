import 'package:flutter/material.dart';
import 'package:todo_list_app/LoginApp/registrationScreen.dart';
import 'package:todo_list_app/Provider/mainProvider.dart';
import 'package:todo_list_app/TodoApp/listMain.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../TodoApp/jsonMain.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connexion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreenHomePage(),
    );
  }
}

class LoginScreenHomePage extends StatefulWidget {
  const LoginScreenHomePage({super.key});

  @override
  _LoginScreenHomePageState createState() => _LoginScreenHomePageState();
}

class _LoginScreenHomePageState extends State<LoginScreenHomePage> {
  String _selectedLoginMethod = 'PHONE';
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _loginUser() async {
    final String phone = _phoneController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? storedPhone = prefs.getString('phone');
    final String? storedEmail = prefs.getString('email');
    final String? storedPassword = prefs.getString('password');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
          if ((_selectedLoginMethod == 'PHONE' &&
                  phone == storedPhone &&
                  password == storedPassword) ||
              (_selectedLoginMethod == 'EMAIL' &&
                  email == storedEmail &&
                  password == storedPassword)) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TodoListAppMultiProvider(),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Erreur de connexion'),
                  content: const Text(
                      'Les informations de connexion sont incorrectes.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        });
        return const AlertDialog(
          title: Text('Connexion en cours'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20.0),
              Expanded(child: Text('Veuillez patienter...')),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Image.asset(
                  "assets/images/login.jpg",
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ),
            ),
            const Text(
              'Mode de connexion',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Radio(
                  value: 'PHONE',
                  groupValue: _selectedLoginMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedLoginMethod = value!;
                    });
                  },
                ),
                const Text('Téléphone'),
                const SizedBox(width: 20.0),
                Radio(
                  value: 'EMAIL',
                  groupValue: _selectedLoginMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedLoginMethod = value!;
                    });
                  },
                ),
                const Text('E-mail'),
              ],
            ),
            const SizedBox(height: 20.0),
            if (_selectedLoginMethod == 'PHONE')
              TextFormField(
                key: const Key('phoneField'),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                ),
              ),
            if (_selectedLoginMethod == 'EMAIL')
              TextFormField(
                key: const Key('emailField'),
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 20.0),
            TextFormField(
              key: const Key('passwordField'),
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.key_sharp),
                suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                    onPressed: _loginUser,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 90, 15, 110),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ))),
            const SizedBox(height: 20.0),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('Mot de passe oublié ?'),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationScreen(),
                    ),
                  );
                },
                child: const Text('Créer un nouveau compte'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
