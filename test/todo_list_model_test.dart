// test/todo_list_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/Provider/mainProvider.dart';
// Ajustez le chemin selon votre structure

void main() {
  group('TodoListModel Tests', () {
    late TodoListModel model;

    setUp(() {
      model = TodoListModel();
    });

    test('Initial state is correct', () {
      expect(model.items, []);
      expect(model.isChecked, []);
      expect(model.deletedItems, []);
      expect(model.filter, 'All');
    });

    test('Add item', () {
      model.addItem('Test Task');
      expect(model.items, ['Test Task']);
      expect(model.isChecked, [false]);
    });

    test('Delete checked items', () {
      model.addItem('Task 1');
      model.addItem('Task 2');
      model.toggleItemChecked('Task 1', true);
      model.deleteCheckedItems();
      expect(model.items, ['Task 2']);
      expect(model.isChecked, [false]);
      expect(model.deletedItems, ['Task 1']);
    });

    test('Restore deleted items', () {
      model.addItem('Task 1');
      model.addItem('Task 2');
      model.toggleItemChecked('Task 1', true);
      model.deleteCheckedItems();
      model.restoreDeletedItems();
      expect(model.items, ['Task 2', 'Task 1']);
      expect(model.isChecked, [false, false]);
      expect(model.deletedItems, []);
    });

    test('Apply filter', () {
      model.addItem('Task 1');
      model.addItem('Task 2');
      model.toggleItemChecked('Task 1', true);
      model.applyFilter();
      expect(model.filteredItems, ['Task 1', 'Task 2']);
      model.filter = 'Finish';
      model.applyFilter();
      expect(model.filteredItems, ['Task 1']);
      model.filter = 'Not Finish';
      model.applyFilter();
      expect(model.filteredItems, ['Task 2']);
    });
  });
}
