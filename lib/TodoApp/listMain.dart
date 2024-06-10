import 'package:flutter/material.dart';

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

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

  void _addItem(String item) {
    setState(() {
      if (item.isNotEmpty) {
        _items.add(item);
        _isChecked.add(false);
        _controller.clear();
      }
    });
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
  }

  void _restoreDeletedItems() {
    setState(() {
      for (var item in _deletedItems) {
        _items.add(item);
        _isChecked.add(false);
      }
      _deletedItems.clear();
    });
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
              } else if (value == 'Supprimer les tâches cochées') {
                _deleteCheckedItems();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Restaurer', 'Supprimer les tâches cochées'}
                  .map((String choice) {
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
