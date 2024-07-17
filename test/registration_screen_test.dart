import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/LoginApp/registrationScreen.dart'; // Ajustez le chemin selon votre structure

void main() {
  group('RegistrationScreen Tests', () {
    testWidgets('Initial state is correct', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegistrationScreen()));
      // Vérifiez l'état initial de l'écran d'inscription
      expect(find.text('Register'), findsOneWidget);
      expect(find.byType(TextField),
          findsNWidgets(2)); // Vérifie deux champs de texte
    });

    testWidgets('Registration form works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegistrationScreen()));
      await tester.enterText(find.byType(TextField).first, 'testuser');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.tap(find.text('Register'));
      await tester.pump();

      // Ajoutez des assertions spécifiques à votre logique de formulaire d'inscription
    });
  });
}
