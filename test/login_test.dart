import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/LoginApp/registrationScreen.dart';
import 'package:todo_list_app/LoginApp/signIn.dart';
import 'package:todo_list_app/Provider/mainProvider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tests unitaires pour LoginScreen', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'phone': '1234567890',
        'email': 'test@example.com',
        'password': 'password123'
      });
    });

    testWidgets('Affichage de l\'écran de connexion',
        (WidgetTester tester) async {
      await tester.pumpWidget(const LoginScreen());
      await tester
          .pumpAndSettle(); // Assurer que le widget est complètement rendu

      expect(find.text('Mode de connexion'), findsOneWidget);
      expect(find.text('Se connecter'), findsOneWidget);
    });

    testWidgets('Connexion réussie', (WidgetTester tester) async {
      await tester.pumpWidget(const LoginScreen());
      await tester
          .pumpAndSettle(); // Assurer que le widget est complètement rendu

      // Entrer le numéro de téléphone et le mot de passe corrects
      await tester.enterText(find.byKey(const Key('phoneField')), '1234567890');
      await tester.enterText(
          find.byKey(const Key('passwordField')), 'password123');
      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      // Attendre que le dialog de connexion disparaisse
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Vérifier la navigation vers l'écran de TodoList
      expect(find.byType(TodoListAppMultiProvider), findsOneWidget);
    });

    testWidgets('Connexion réussie', (WidgetTester tester) async {
      await tester.pumpWidget(const LoginScreen());
      await tester
          .pumpAndSettle(); // Assurer que le widget est complètement rendu

      // Entrer le numéro de téléphone et le mot de passe corrects
      await tester.enterText(find.byType(TextFormField).at(0), '1234567890');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      // Attendre que le dialog de connexion disparaisse
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Vérifier la navigation vers l'écran de TodoList
      expect(find.byType(TodoListAppMultiProvider), findsOneWidget);
    });

    testWidgets('Connexion échouée', (WidgetTester tester) async {
      await tester.pumpWidget(const LoginScreen());
      await tester
          .pumpAndSettle(); // Assurer que le widget est complètement rendu

      // Entrer un numéro de téléphone incorrect et un mot de passe incorrects
      await tester.enterText(find.byType(TextFormField).at(0), '0987654321');
      await tester.enterText(find.byType(TextFormField).at(1), 'wrongpassword');
      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      // Attendre que le dialog de connexion disparaisse
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Vérifier que le dialog d'erreur de connexion est affiché
      expect(find.text('Erreur de connexion'), findsOneWidget);
      expect(find.text('Les informations de connexion sont incorrectes.'),
          findsOneWidget);
    });

    testWidgets('Navigation vers l\'écran d\'inscription',
        (WidgetTester tester) async {
      await tester.pumpWidget(const LoginScreen());
      await tester
          .pumpAndSettle(); // Assurer que le widget est complètement rendu

      // Cliquer sur le bouton 'Créer un nouveau compte'
      await tester.tap(find.text('Créer un nouveau compte'));
      await tester.pumpAndSettle();

      // Vérifier la navigation vers l'écran d'inscription
      expect(find.byType(RegistrationScreen), findsOneWidget);
    });
  });
}
