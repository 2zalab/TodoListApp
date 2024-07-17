import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/Riverpod/mainRiverpod.dart';

void main() {
  group('Tests unitaires pour TodoListApp avec Riverpod', () {
    testWidgets('Affichage de la liste des tâches',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: TodoListAppRiverpod()));

      expect(find.text('Todo List Home Page'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('Ajout de tâche', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: TodoListAppRiverpod()));

      final textField = find.byType(TextField);
      final addButton = find.byIcon(Icons.add);

      await tester.enterText(textField, 'Nouvelle tâche');
      await tester.tap(addButton);
      await tester.pump();

      expect(find.text('Nouvelle tâche'), findsOneWidget);
    });

    testWidgets('Suppression des tâches cochées', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: TodoListAppRiverpod()));

      final textField = find.byType(TextField);
      final addButton = find.byIcon(Icons.add);

      // Ajouter une tâche
      await tester.enterText(textField, 'Tâche à supprimer');
      await tester.tap(addButton);
      await tester.pump();

      // Cocher la tâche
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Ouvrir le menu contextuel
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Supprimer la tâche cochée
      await tester.tap(find.text('Delete Checked Items'));
      await tester.pumpAndSettle();

      // Vérifier que la tâche a été supprimée
      expect(find.text('Tâche à supprimer'), findsNothing);
    });

    testWidgets('Restauration des tâches supprimées',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: TodoListAppRiverpod()));

      final textField = find.byType(TextField);
      final addButton = find.byIcon(Icons.add);

      // Ajouter une tâche
      await tester.enterText(textField, 'Tâche supprimée');
      await tester.tap(addButton);
      await tester.pump();

      // Cocher la tâche
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Ouvrir le menu contextuel
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Supprimer la tâche cochée
      await tester.tap(find.text('Delete Checked Items'));
      await tester.pumpAndSettle();

      // Ouvrir le menu contextuel
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Restaurer la tâche supprimée
      await tester.tap(find.text('Restore'));
      await tester.pumpAndSettle();

      // Vérifier que la tâche a été restaurée
      expect(find.text('Tâche supprimée'), findsOneWidget);
    });

    testWidgets('Filtrage des tâches', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: TodoListAppRiverpod()));

      final textField = find.byType(TextField);
      final addButton = find.byIcon(Icons.add);

      await tester.enterText(textField, 'Tâche 1');
      await tester.tap(addButton);
      await tester.enterText(textField, 'Tâche 2');
      await tester.tap(addButton);
      await tester.pump();

      final checkboxes = find.byType(Checkbox);
      await tester.tap(checkboxes.at(0));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      expect(find.text('Tâche 1'), findsOneWidget);
      expect(find.text('Tâche 2'), findsNothing);
    });
  });
}
