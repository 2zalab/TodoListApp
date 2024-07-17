import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/LoginApp/registrationScreen.dart';
import 'package:todo_list_app/LoginApp/signIn.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tests unitaires pour RegistrationScreen', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Affichage de l\'écran d\'inscription',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RegistrationScreen());
      await tester.pumpAndSettle(); // Assurer que le widget est complètement rendu

      expect(find.byKey(const Key('registrationTitle')), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4)); // Quatre champs de texte
      expect(find.byKey(const Key('registerButton')), findsOneWidget);
    });

    testWidgets('Enregistrement de l\'utilisateur avec succès',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RegistrationScreen());
      await tester.pumpAndSettle(); // Assurer que le widget est complètement rendu

      // Entrer les informations de l'utilisateur
      await tester.enterText(find.byKey(const Key('nameField')), 'Nom Test');
      await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('phoneField')), '1234567890');
      await tester.enterText(find.byKey(const Key('passwordField')), 'password123');

      // Vérification des valeurs avant de continuer
      expect(find.byKey(const Key('nameField')), findsOneWidget);
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('phoneField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);

      tester.printToConsole('Les champs de texte sont remplis.');

      await tester.tap(find.byKey(const Key('registerButton')));
      await tester.pumpAndSettle();

      // Attendre que le dialog d'enregistrement disparaisse
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Vérifier la navigation vers l'écran de connexion
      expect(find.byType(LoginScreen), findsOneWidget);

      // Vérifier que les informations sont bien enregistrées
      SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('name'), 'Nom Test');
      expect(prefs.getString('email'), 'test@example.com');
      expect(prefs.getString('phone'), '1234567890');
      expect(prefs.getString('password'), 'password123');
    });

    testWidgets('Enregistrement échoué en raison de champs manquants',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RegistrationScreen());
      await tester.pumpAndSettle(); // Assurer que le widget est complètement rendu

      // Laisser les champs vides
      await tester.tap(find.byKey(const Key('registerButton')));
      await tester.pumpAndSettle();

      // Vérifier que le SnackBar est affiché
      expect(find.text('Veuillez remplir tous les champs'), findsOneWidget);
    });

    testWidgets('Navigation vers l\'écran de connexion',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RegistrationScreen());
      await tester.pumpAndSettle(); // Assurer que le widget est complètement rendu

      // Cliquer sur le bouton 'Déjà un compte ? Connexion'
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      // Vérifier la navigation vers l'écran de connexion
      expect(find.byType(LoginScreen), findsOneWidget,
          reason: 'LoginScreen should be found');
      tester.printToConsole('Navigué vers LoginScreen');
    });
  });
}
