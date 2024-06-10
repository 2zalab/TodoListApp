import 'package:flutter/material.dart';
import 'package:todo_list_app/TodoApp/listMain.dart';

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
  // ignore: library_private_types_in_public_api
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar( title: Text('Connexion'),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Image.asset(
                  "assets/images/login_image.png",
                  width: MediaQuery.of(context).size.width *
                      0.7, // Adjust width as needed
                  height: MediaQuery.of(context).size.height *
                      0.2, // Adjust height as needed
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
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(), // Ajouter une bordure
                ),
              ),
            if (_selectedLoginMethod == 'EMAIL')
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: 'E-mail',
                  border: OutlineInputBorder(), // Ajouter une bordure
                ),
              ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: const OutlineInputBorder(), // Ajouter une bordure
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
                child: ElevatedButton(
                    onPressed: () {
                      // naviguer vers l'acceuil de TodoAPP
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TodoListApp()),
                      );
                    },
                    child: const Text(
                      'Se connecter',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ))),
            const SizedBox(height: 20.0),
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: Implémenter la logique de mot de passe oublié
                },
                child: const Text('Mot de passe oublié ?'),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: Implémenter la logique de création de compte
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
