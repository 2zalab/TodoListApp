import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/Provider/mainProvider.dart';
import 'package:todo_list_app/TodoApp/listMain.dart';

void main() {
  testWidgets('Todo List App Test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(TodoListAppMultiProvider());

    // Verify the initial state of the Todo List.
    expect(find.text('Enter a new Task'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);

    // Add a new task.
    await tester.enterText(find.byType(TextField), 'Test Task');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the new task is added.
    expect(find.text('Test Task'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);

    // Check the task.
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();

    // Verify that the task is checked.
    Checkbox checkbox = tester.widget(find.byType(Checkbox).first);
    expect(checkbox.value, true);

    // Delete the task.
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pump();

    // Verify that the task is deleted.
    expect(find.text('Test Task'), findsNothing);
    expect(find.byType(ListTile), findsNothing);
  });
}
