import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class TodoListAppApi extends StatelessWidget {
  const TodoListAppApi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Todo List Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _items = [];
  final List<bool> _isChecked = [];
  final List<String> _deletedItems = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final data = await _fetchTasksFromAPI();
    setState(() {
      _items.clear();
      _isChecked.clear();
      for (var item in data) {
        _items.add(item['title']);
        _isChecked.add(item['checked']);
      }
    });
  }

  Future<List<Map<String, dynamic>>> _fetchTasksFromAPI() async {
    const String baseURL = 'http://localhost:5000/api';

    final response = await http.get(Uri.parse('$baseURL/tasks'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> _saveItems() async {
    final file = await _getLocalFile();
    final data = {
      'items': _items
          .asMap()
          .entries
          .map((entry) => {
                'title': entry.value,
                'checked': _isChecked[entry.key],
              })
          .toList(),
    };
    await file.writeAsString(json.encode(data));
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todo_list.json');
  }

  void _addItem(String item) async {
    try {
      await _addTaskViaAPI(item);
      _loadItems();
      _controller.clear();
    } catch (e) {
      print('Error adding task: $e');
      // Gérer l'erreur d'ajout de tâche via l'API
    }
  }

  Future<void> _addTaskViaAPI(String title) async {
    const String baseURL = 'http://localhost:5000/api';

    final response = await http.post(
      Uri.parse('$baseURL/tasks'),
      body: json.encode({'title': title, 'checked': false}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add task');
    }
  }

  void _deleteCheckedItems() {
    setState(() {
      List<String> newItems = [];
      List<bool> newIsChecked = [];

      for (int i = 0; i < _items.length; i++) {
        if (!_isChecked[i]) {
          newItems.add(_items[i]);
          newIsChecked.add(false);
        } else {
          _deletedItems.add(_items[i]);
        }
      }

      _items.clear();
      _items.addAll(newItems);

      _isChecked.clear();
      _isChecked.addAll(newIsChecked);
    });
    _saveItems();
  }

  void _restoreDeletedItems() {
    setState(() {
      for (var item in _deletedItems) {
        _items.add(item);
        _isChecked.add(false);
      }
      _deletedItems.clear();
    });
    _saveItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'Restaurer') {
                _restoreDeletedItems();
              } else if (value == 'Delete Checked Items') {
                _deleteCheckedItems();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Restaurer', 'Delete Checked Items'}.map((String choice) {
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
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_items[index]),
                  trailing: Checkbox(
                    value: _isChecked[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked[index] = value!;
                      });
                      _saveItems();
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                10, 15, 15, 20), //const EdgeInsets.all(10.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Saisir une nouvelle Tâche',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _addItem(_controller.text);
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
