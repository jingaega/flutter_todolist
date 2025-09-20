import 'package:flutter/material.dart';

// Abstraction: abstract base class defining common Task behavior
abstract class Task {
  // Encapsulation: private field for title
  String _title;
  bool _isDone;

  Task(this._title) : _isDone = false;

  // Encapsulation: getter and setter for title
  String get title => _title;
  set title(String newTitle) {
    if (newTitle.isNotEmpty) {
      _title = newTitle;
    }
  }

  // Encapsulation: getter for isDone
  bool get isDone => _isDone;

  // Abstraction: method to toggle done state
  void toggleDone() {
    _isDone = !_isDone;
  }
}

// Inheritance: Concrete TodoTask extends abstract Task
class TodoTask extends Task {
  TodoTask(super.title);

  // Additional behavior could be added here
}

// Composition/Aggregation: Manager holds and manages a list of Tasks
class TaskManager {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(Task task) {
    _tasks.add(task);
  }

  void removeTask(Task task) {
    _tasks.remove(task);
  }

  void toggleTask(Task task) {
    task.toggleDone();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OOP To-Do List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final TaskManager _manager = TaskManager();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OOP To-Do List')),
      body: Column(
        children: [          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [                
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'New task'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        // Composition: adding a new TodoTask to manager
                        _manager.addTask(TodoTask(_controller.text));
                        _controller.clear();
                      });
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: _manager.tasks.map((task) {
                return ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (_) {
                      setState(() {
                        _manager.toggleTask(task);
                      });
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _manager.removeTask(task);
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
