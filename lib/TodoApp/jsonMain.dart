import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class TodoListAppJson extends StatelessWidget {
  const TodoListAppJson({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
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
  List<String> _filteredItems = [];
  String _filter = 'All';

  void _showFilterOptions(BuildContext context) {
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
                  setState(() {
                    _filter = 'All';
                    _applyFilter();
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Finish'),
                onTap: () {
                  setState(() {
                    _filter = 'Finish';
                    _applyFilter();
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Not Finish'),
                onTap: () {
                  setState(() {
                    _filter = 'Not Finish';
                    _applyFilter();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilter() {
    setState(() {
      if (_filter == 'All') {
        _filteredItems = List.from(_items);
      } else if (_filter == 'Finish') {
        _filteredItems =
            _items.where((item) => _isChecked[_items.indexOf(item)]).toList();
      } else if (_filter == 'Not Finish') {
        _filteredItems =
            _items.where((item) => !_isChecked[_items.indexOf(item)]).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItems().then((_) {
      _applyFilter();
    });
  }

  Future<void> _loadItems() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final contents = await file.readAsString();
      final data = json.decode(contents);
      setState(() {
        _items.clear();
        _isChecked.clear();
        for (var item in data['items']) {
          _items.add(item['title']);
          _isChecked.add(item['checked']);
        }
      });
    } else {
      // Load the initial data from the asset file if the local file does not exist
      final contents = await rootBundle.loadString('assets/task_list.json');
      final data = json.decode(contents);
      setState(() {
        _items.clear();
        _isChecked.clear();
        for (var item in data['items']) {
          _items.add(item['title']);
          _isChecked.add(item['checked']);
        }
      });
      _saveItems();
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
    return File('${directory.path}/task_list.json');
  }

  void _addItem(String item) {
    setState(() {
      if (item.isNotEmpty) {
        _items.add(item);
        _isChecked.add(false);
        _controller.clear();
      }
    });
    _saveItems();
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
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'Restore') {
                _restoreDeletedItems();
              } else if (value == 'Delete Checked Items') {
                _deleteCheckedItems();
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
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredItems[index]),
                  trailing: Checkbox(
                    value: _isChecked[_items.indexOf(_filteredItems[index])],
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked[_items.indexOf(_filteredItems[index])] =
                            value!;
                      });
                      _saveItems();
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 15, 20),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter a new Task',
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
