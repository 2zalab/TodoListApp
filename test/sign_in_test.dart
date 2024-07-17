import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/LoginApp/signIn.dart';
// Ajustez le chemin selon votre structure

void main() {
  group('SignInScreen Tests', () {
    testWidgets('Initial state is correct', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));
      // Vérifiez l'état initial de l'écran de connexion
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(TextField),
          findsNWidgets(2)); // Vérifie deux champs de texte
    });

    testWidgets('Sign-in form works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));
      await tester.enterText(find.byType(TextField).first, 'testuser');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Ajoutez des assertions spécifiques à votre logique de formulaire de connexion
    });
  });
}
