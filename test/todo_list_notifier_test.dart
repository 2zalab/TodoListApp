// test/todo_list_notifier_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart'; // Ajustez le chemin selon votre structure
import 'package:todo_list_app/Riverpod/mainRiverpod.dart';

void main() {
  group('TodoListNotifier Tests', () {
    late ProviderContainer container;
    late TodoListNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(todoListProvider.notifier);
    });

    test('Initial state is correct', () {
      final state = container.read(todoListProvider);
      expect(state.items, []);
      expect(state.isChecked, []);
      expect(state.deletedItems, []);
      expect(state.filter, 'All');
    });

    test('Add item', () {
      notifier.addItem('Test Task');
      final state = container.read(todoListProvider);
      expect(state.items, ['Test Task']);
      expect(state.isChecked, [false]);
    });

    test('Delete checked items', () {
      notifier.addItem('Task 1');
      notifier.addItem('Task 2');
      notifier.toggleItemChecked('Task 1', true);
      notifier.deleteCheckedItems();
      final state = container.read(todoListProvider);
      expect(state.items, ['Task 2']);
      expect(state.isChecked, [false]);
      expect(state.deletedItems, ['Task 1']);
    });

    test('Restore deleted items', () {
      notifier.addItem('Task 1');
      notifier.addItem('Task 2');
      notifier.toggleItemChecked('Task 1', true);
      notifier.deleteCheckedItems();
      notifier.restoreDeletedItems();
      final state = container.read(todoListProvider);
      expect(state.items, ['Task 2', 'Task 1']);
      expect(state.isChecked, [false, false]);
      expect(state.deletedItems, []);
    });

    test('Apply filter', () {
      notifier.addItem('Task 1');
      notifier.addItem('Task 2');
      notifier.toggleItemChecked('Task 1', true);
      notifier.applyFilter();
      final state = container.read(todoListProvider);
      expect(state.filteredItems, ['Task 1', 'Task 2']);
      notifier.state = state.copy()..filter = 'Finish';
      notifier.applyFilter();
      expect(state.filteredItems, ['Task 1']);
      notifier.state = state.copy()..filter = 'Not Finish';
      notifier.applyFilter();
      expect(state.filteredItems, ['Task 2']);
    });
  });
}
