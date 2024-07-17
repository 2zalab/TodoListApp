import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/TodoApp/listMain.dart'; // Ajustez le chemin selon votre structure

void main() {
  group('ListMain Tests', () {
    testWidgets('Display list of items', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TodoListApp()));
      // Ajoutez des éléments à la liste
      await tester.enterText(find.byType(TextField), 'Item 1');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('Add item to the list', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TodoListApp()));
      await tester.enterText(find.byType(TextField), 'NewItem');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('NewItem'), findsOneWidget);
    });

    testWidgets('Delete item from the list', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TodoListApp()));
      await tester.enterText(find.byType(TextField), 'Item to delete');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('Item to delete'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pump();

      expect(find.text('Item to delete'), findsNothing);
    });
  });
}
