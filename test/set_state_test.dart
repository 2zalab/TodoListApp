import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/TodoApp/jsonMain.dart';
import 'package:todo_list_app/main.dart';

void main() {
  group('TodoListAppJson Widget Tests', () {
    testWidgets('TodoListAppJson has a title and home page',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TodoListAppJson());
      expect(find.text('Todo List Home Page'), findsOneWidget);
    });
  });

  group('MyHomePage Widget Tests', () {
    testWidgets('MyHomePage has a title', (WidgetTester tester) async {
      await tester
          .pumpWidget(MaterialApp(home: MyHomePage(title: 'Test Title')));
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('Can add a new task', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MyHomePage(title: 'Test')));

      // Entrer le texte dans le champ de texte
      await tester.enterText(find.byType(TextField), 'New Task');
      await tester.pump();

      // Appuyer sur le bouton d'ajout
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Vérifier si la nouvelle tâche est présente
      expect(find.text('New Task'), findsOneWidget);
    });

    testWidgets('Can check a task', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MyHomePage(title: 'Test')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Task to Check');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(checkbox.value, isTrue);
    });

    testWidgets('Can filter tasks', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MyHomePage(title: 'Test')));
      await tester.pumpAndSettle();

      // Ajouter deux tâches
      await tester.enterText(find.byType(TextField), 'Task 1');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Task 2');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Cocher la première tâche
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Ouvrir les options de filtre
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      // Sélectionner le filtre 'Finish'
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsNothing);
    });

    testWidgets('Can delete checked items', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MyHomePage(title: 'Test')));
      await tester.pumpAndSettle();

      // Ajouter deux tâches
      await tester.enterText(find.byType(TextField), 'Task 1');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Task 2');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Cocher la première tâche
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Supprimer les éléments cochés
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete Checked Items'));
      await tester.pumpAndSettle();

      expect(find.text('Task 1'), findsNothing);
      expect(find.text('Task 2'), findsOneWidget);
    });

    testWidgets('Can restore deleted items', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MyHomePage(title: 'Test')));
      await tester.pumpAndSettle();

      // Ajouter une tâche et la supprimer
      await tester.enterText(find.byType(TextField), 'Task to Delete');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete Checked Items'));
      await tester.pumpAndSettle();

      // Restaurer les éléments supprimés
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Restore'));
      await tester.pumpAndSettle();

      // Vérifier si la tâche est restaurée
      expect(find.text('Task to Delete'), findsOneWidget);
    });
  });
}
