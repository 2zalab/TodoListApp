// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(ProviderScope(child: TodoListAppRiverpod()));

class TodoListAppRiverpod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Todo List Home Page'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final todoList = watch(todoListProvider);
    final textController = watch(textEditingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              context
                  .read(todoListProvider.notifier)
                  .showFilterOptions(context);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'Restore') {
                context.read(todoListProvider.notifier).restoreDeletedItems();
              } else if (value == 'Delete Checked Items') {
                context.read(todoListProvider.notifier).deleteCheckedItems();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Restore', 'Delete Checked Items'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: todoList.filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todoList.filteredItems[index]),
                  trailing: Checkbox(
                    value: todoList.isChecked[
                        todoList.items.indexOf(todoList.filteredItems[index])],
                    onChanged: (bool? value) {
                      context.read(todoListProvider.notifier).toggleItemChecked(
                          todoList.filteredItems[index], value!);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 15, 20),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Enter a new Task',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context
                        .read(todoListProvider.notifier)
                        .addItem(textController.text);
                    textController.clear();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoListNotifier extends StateNotifier<TodoListModel> {
  TodoListNotifier() : super(TodoListModel()) {
    loadItems().then((_) {
      applyFilter();
    });
  }

  void showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Tasks'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('All'),
                onTap: () {
                  state = state.copy()..filter = 'All';
                  applyFilter();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Finish'),
                onTap: () {
                  state = state.copy()..filter = 'Finish';
                  applyFilter();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Not Finish'),
                onTap: () {
                  state = state.copy()..filter = 'Not Finish';
                  applyFilter();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void applyFilter() {
    if (state.filter == 'All') {
      state = state.copy()..filteredItems = List.from(state.items);
    } else if (state.filter == 'Finish') {
      state = state.copy()
        ..filteredItems = state.items
            .where((item) => state.isChecked[state.items.indexOf(item)])
            .toList();
    } else if (state.filter == 'Not Finish') {
      state = state.copy()
        ..filteredItems = state.items
            .where((item) => !state.isChecked[state.items.indexOf(item)])
            .toList();
    }
  }

  Future<void> loadItems() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final contents = await file.readAsString();
      final data = json.decode(contents);
      state = state.copy()
        ..items.clear()
        ..isChecked.clear();
      for (var item in data['items']) {
        state.items.add(item['title']);
        state.isChecked.add(item['checked']);
      }
    } else {
      final contents = await rootBundle.loadString('assets/task_list.json');
      final data = json.decode(contents);
      state = state.copy()
        ..items.clear()
        ..isChecked.clear();
      for (var item in data['items']) {
        state.items.add(item['title']);
        state.isChecked.add(item['checked']);
      }
      saveItems();
    }
  }

  Future<void> saveItems() async {
    final file = await _getLocalFile();
    final data = {
      'items': state.items
          .asMap()
          .entries
          .map((entry) => {
                'title': entry.value,
                'checked': state.isChecked[entry.key],
              })
          .toList(),
    };
    await file.writeAsString(json.encode(data));
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/task_list.json');
  }

  void addItem(String item) {
    if (item.isNotEmpty) {
      state = state.copy()
        ..items.add(item)
        ..isChecked.add(false);
      applyFilter();
      saveItems();
    }
  }

  void deleteCheckedItems() {
    final newItems = <String>[];
    final newIsChecked = <bool>[];
    for (int i = 0; i < state.items.length; i++) {
      if (!state.isChecked[i]) {
        newItems.add(state.items[i]);
        newIsChecked.add(false);
      } else {
        state.deletedItems.add(state.items[i]);
      }
    }
    state = state.copy()
      ..items.clear()
      ..items.addAll(newItems)
      ..isChecked.clear()
      ..isChecked.addAll(newIsChecked);
    applyFilter();
    saveItems();
  }

  void restoreDeletedItems() {
    for (var item in state.deletedItems) {
      state.items.add(item);
      state.isChecked.add(false);
    }
    state = state.copy()..deletedItems.clear();
    applyFilter();
    saveItems();
  }

  void toggleItemChecked(String item, bool value) {
    state.isChecked[state.items.indexOf(item)] = value;
    applyFilter();
    saveItems();
  }
}

class TodoListModel {
  List<String> items = [];
  List<bool> isChecked = [];
  List<String> deletedItems = [];
  List<String> filteredItems = [];
  String filter = 'All';

  TodoListModel copy() {
    return TodoListModel()
      ..items = List.from(items)
      ..isChecked = List.from(isChecked)
      ..deletedItems = List.from(deletedItems)
      ..filteredItems = List.from(filteredItems)
      ..filter = filter;
  }
}

final todoListProvider =
    StateNotifierProvider<TodoListNotifier, TodoListModel>((ref) {
  return TodoListNotifier();
});
final textEditingControllerProvider = Provider<TextEditingController>((ref) {
  return TextEditingController();
});
