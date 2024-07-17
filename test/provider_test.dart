import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:todo_list_app/Provider/mainProvider.dart';
// Assurez-vous que le chemin est correct
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tests unitaires pour TodoListAppMultiProvider', () {
    setUpAll(() {
      // Simuler le système de fichiers pour les tests
      final directory = Directory.systemTemp.createTempSync();
      PathProviderPlatform.instance = FakePathProviderPlatform(directory);
    });

    testWidgets('Affichage de la liste des tâches', (WidgetTester tester) async {
      await tester.pumpWidget(TodoListAppMultiProvider());
      await tester.pumpAndSettle(); // Assurer que le widget est complètement rendu

      expect(find.text('Todo List Home Page'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('Ajout de tâche', (WidgetTester tester) async {
      await tester.pumpWidget(TodoListAppMultiProvider());
      await tester.pumpAndSettle(); // Assurer que le widget est complètement rendu

      final textField = find.byType(TextField);
      final addButton = find.byIcon(Icons.add);

      await tester.enterText(textField, 'Nouvelle tâche');
      await tester.tap(addButton);
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      expect(find.text('Nouvelle tâche'), findsOneWidget);
    });

    testWidgets('Suppression des tâches cochées', (WidgetTester tester) async {
      await tester.pumpWidget(TodoListAppMultiProvider());
      await tester.pumpAndSettle(); // Assurer que le widget est complètement rendu

      final textField = find.byType(TextField);
      final addButton = find.byIcon(Icons.add);

      // Ajouter une tâche
      await tester.enterText(textField, 'Tâche à supprimer');
      await tester.tap(addButton);
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      // Vérifier que la tâche a été ajoutée
      expect(find.text('Tâche à supprimer'), findsOneWidget);

      // Cocher la tâche
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      // Ouvrir le menu contextuel
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      // Supprimer la tâche cochée
      await tester.tap(find.text('Delete Checked Items'));
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      // Vérifier que la tâche a été supprimée
      expect(find.text('Tâche à supprimer'), findsNothing);
    });

    testWidgets('Restauration des tâches supprimées', (WidgetTester tester) async {
      await tester.pumpWidget(TodoListAppMultiProvider());
      await tester.pumpAndSettle(); // Assurer que le widget est complètement rendu

      final textField = find.byType(TextField);
      final addButton = find.byIcon(Icons.add);

      // Ajouter une tâche
      await tester.enterText(textField, 'Tâche supprimée');
      await tester.tap(addButton);
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      // Vérifier que la tâche a été ajoutée
      expect(find.text('Tâche supprimée'), findsOneWidget);

      // Cocher la tâche
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      // Ouvrir le menu contextuel
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      // Supprimer la tâche cochée
      await tester.tap(find.text('Delete Checked Items'));
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      // Ouvrir le menu contextuel
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      // Restaurer la tâche supprimée
      await tester.tap(find.text('Restore'));
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      // Vérifier que la tâche a été restaurée
      expect(find.text('Tâche supprimée'), findsOneWidget);
    });

    testWidgets('Filtrage des tâches', (WidgetTester tester) async {
      await tester.pumpWidget(TodoListAppMultiProvider());
      await tester.pumpAndSettle(); // Assurer que le widget est complètement rendu

      final textField = find.byType(TextField);
      final addButton = find.byIcon(Icons.add);

      await tester.enterText(textField, 'Tâche 1');
      await tester.tap(addButton);
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      await tester.enterText(textField, 'Tâche 2');
      await tester.tap(addButton);
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsWidgets); // Vérifier que les cases à cocher existent
      await tester.tap(checkboxes.first);
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle(); // Attendre que les animations et les mises à jour se terminent

      expect(find.text('Tâche 1'), findsOneWidget);
      expect(find.text('Tâche 2'), findsNothing);
    });
  });
}

// Simulate file system for the tests
class FakePathProviderPlatform extends PathProviderPlatform {
  final Directory directory;

  FakePathProviderPlatform(this.directory);

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return directory.path;
  }
}
