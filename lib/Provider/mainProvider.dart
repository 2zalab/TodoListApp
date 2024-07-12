// main.dart
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(TodoListAppMultiProvider());

class TodoListAppMultiProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoListModel()),
      ],
      child: MaterialApp(
        title: 'Todo List App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: 'Todo List Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              context.read<TodoListModel>().showFilterOptions(context);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'Restore') {
                context.read<TodoListModel>().restoreDeletedItems();
              } else if (value == 'Delete Checked Items') {
                context.read<TodoListModel>().deleteCheckedItems();
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
            child: Consumer<TodoListModel>(
              builder: (context, model, child) {
                return ListView.builder(
                  itemCount: model.filteredItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(model.filteredItems[index]),
                      trailing: Checkbox(
                        value: model.isChecked[
                            model.items.indexOf(model.filteredItems[index])],
                        onChanged: (bool? value) {
                          model.toggleItemChecked(
                              model.filteredItems[index], value!);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 15, 20),
            child: TextField(
              controller: context.read<TodoListModel>().controller,
              decoration: InputDecoration(
                labelText: 'Enter a new Task',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context
                        .read<TodoListModel>()
                        .addItem(context.read<TodoListModel>().controller.text);
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

class TodoListModel extends ChangeNotifier {
  final List<String> items = [];
  final List<bool> isChecked = [];
  final List<String> deletedItems = [];
  final TextEditingController controller = TextEditingController();
  List<String> filteredItems = [];
  String filter = 'All';

  TodoListModel() {
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
                  filter = 'All';
                  applyFilter();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Finish'),
                onTap: () {
                  filter = 'Finish';
                  applyFilter();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Not Finish'),
                onTap: () {
                  filter = 'Not Finish';
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
    if (filter == 'All') {
      filteredItems = List.from(items);
    } else if (filter == 'Finish') {
      filteredItems =
          items.where((item) => isChecked[items.indexOf(item)]).toList();
    } else if (filter == 'Not Finish') {
      filteredItems =
          items.where((item) => !isChecked[items.indexOf(item)]).toList();
    }
    notifyListeners();
  }

  Future<void> loadItems() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final contents = await file.readAsString();
      final data = json.decode(contents);
      items.clear();
      isChecked.clear();
      for (var item in data['items']) {
        items.add(item['title']);
        isChecked.add(item['checked']);
      }
    } else {
      // Load the initial data from the asset file if the local file does not exist
      final contents = await rootBundle.loadString('assets/task_list.json');
      final data = json.decode(contents);
      items.clear();
      isChecked.clear();
      for (var item in data['items']) {
        items.add(item['title']);
        isChecked.add(item['checked']);
      }
      saveItems();
    }
    notifyListeners();
  }

  Future<void> saveItems() async {
    final file = await _getLocalFile();
    final data = {
      'items': items
          .asMap()
          .entries
          .map((entry) => {
                'title': entry.value,
                'checked': isChecked[entry.key],
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
      items.add(item);
      isChecked.add(false);
      controller.clear();
      applyFilter();
      saveItems();
    }
  }

  void deleteCheckedItems() {
    List<String> newItems = [];
    List<bool> newIsChecked = [];
    for (int i = 0; i < items.length; i++) {
      if (!isChecked[i]) {
        newItems.add(items[i]);
        newIsChecked.add(false);
      } else {
        deletedItems.add(items[i]);
      }
    }
    items.clear();
    items.addAll(newItems);
    isChecked.clear();
    isChecked.addAll(newIsChecked);
    applyFilter();
    saveItems();
  }

  void restoreDeletedItems() {
    for (var item in deletedItems) {
      items.add(item);
      isChecked.add(false);
    }
    deletedItems.clear();
    applyFilter();
    saveItems();
  }

  void toggleItemChecked(String item, bool value) {
    isChecked[items.indexOf(item)] = value;
    applyFilter();
    saveItems();
  }
}
